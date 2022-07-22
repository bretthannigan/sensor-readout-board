import sys
import os
import queue
import signal
import datetime
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from time import sleep
from collections import deque
import numpy as np
import threading

from SensorDataParser import *
import PollMIN
import RepeatedTimer
import argparse

# Command line parameters
parser = argparse.ArgumentParser(description='Logging utility for MENRVA sensor readout board.')
parser.add_argument('--port', dest='port', action='store', default="COM12", help='Serial port for readout board.')
parser.add_argument('--logfile', dest='logfile', action='store', default=datetime.datetime.now().strftime("Log_%Y-%m-%dT%H%M%S.tsv"), help='Custom log file name.')
parser.add_argument('--plot', dest='plot', action='store_true', default=True, help='Turn on/off plotting data (default=on)')
parser.add_argument('--mode', dest='mode', action='store', choices=['raw', 'iq', 'model', 'magphase', 'RCseries', 'RCparallel'], default='model', help='Impedance calculation mode.')
parser.add_argument('--gain', dest='gain', action='store', type=float, choices=[1e-2, 1e-3, 1e-4, 1e-5], default=1e-5, help='Gain setting selected with readout board jumper.')
parser.add_argument('--exc_amp', dest='excitation_amplitude', action='store', default=0.33, help='Excitation sine wave scaling factor.')
parser.add_argument('--trig', dest='is_triggered', action='store_true', default=False, help='Enable triggering of logging from the device.')
parser.add_argument('--cal', dest='is_calibration', action='store_true', default=False, help='Enable adjustment of measurement using IQ calibration data.')
parser.add_argument('--model', dest='model_path', action='store', default='model.sav', help='Path to model (only applicable for \'model\' calibration mode).')
args = parser.parse_args()

class ReadSensor:

    __version__ = '0.3'
    __board_rev__ = 'B'
    DATA_UPDATE_PERIOD = 1
    PLOT_UPDATE_PERIOD = 1
    dtype = [('Timestamp', (np.str_, 24)), ('Ch0', np.double), ('Ch1', np.double), ('Ch2', np.double), ('Ch3', np.double)]
    #excitation_frequency = np.array([1556.0, 3113.0, 6226.0, 12451.0, 24902.0, 49805.0, 99609.0]) # Hz
    #excitation_frequency = np.array([99609.0]) # Hz
    excitation_frequency = np.array([99609.0, 49805.0, 24902.0, 12451.0]) # Hz
    lock = threading.Lock()

    def __init__(self, port):
        self.splash()
        self.port = port
        sys.stdout.write('\t=====Listening on port: ' + args.port + '=====\n')
        self.x_plot = deque(maxlen=100)
        self.y_plot = deque(maxlen=100)
        self.initialized = False
        self._was_triggered = False

    def splash(self):
        sys.stdout.write('\n')
        with open('ETH.txt', 'r') as f:
            sys.stdout.write(f.read())
        sys.stdout.write(' BMHT Sensor Readout Client v' + self.__version__ + ' (board revision ' + self.__board_rev__ + ')' '\n\n')

    def start(self):
        self.rx_q = queue.Queue(32786)
        self.min = PollMIN.PollMIN(self.port, self.rx_q)
        self.min.start()
        sys.stdout.write('\t=====Waiting for first packet.=====\n')
        self._init_parser()
        self.rx_q.queue.clear()
        self._start_time = datetime.datetime.now()
        self.update_timer = RepeatedTimer.RepeatedTimer(self.DATA_UPDATE_PERIOD, self.update)
        self.update_timer.start()

    def _init_ch(self, hdr, n):
        if args.mode == 'raw':
            self.parser = SensorDataParserRaw(n, args.excitation_amplitude, self.excitation_frequency, args.gain)
        elif args.mode == 'iq':
            self.parser = SensorDataParserIQ(n, args.excitation_amplitude, self.excitation_frequency, args.gain, is_calibration=args.is_calibration)
        elif args.mode == 'model':
            self.parser = SensorDataParserModel(n, args.excitation_amplitude, self.excitation_frequency, args.gain, is_calibration=args.is_calibration, model_path=args.model_path)
        elif args.mode == 'magphase':
            self.parser = SensorDataParserMagPhase(n, args.excitation_amplitude, self.excitation_frequency, args.gain, is_calibration=args.is_calibration)
        elif args.mode == 'RCseries':
            self.parser = SensorDataParserRCSeries(n, args.excitation_amplitude, self.excitation_frequency, args.gain, is_calibration=args.is_calibration)
        elif args.mode == 'RCparallel':
            self.parser = SensorDataParserRCParallel(n, args.excitation_amplitude, self.excitation_frequency, args.gain, is_calibration=args.is_calibration)
        self.initialized = True
        sys.stdout.write('\t=====Detected ' + str(n) + ' channel(s).=====\n')

    def _init_logfile(self, hdr):
        log_header = 'Timestamp'
        for i in range(self.parser.n_ch*self.parser.n_sig_per_ch):
            log_header = log_header + '\t' + self.parser.dtype[i][0]
        log_header = log_header + '\n'
        with open(args.logfile, 'xt') as f:
            f.write(log_header)

    def _init_parser(self):
        while not self.initialized:
            try:
                item = self.rx_q.get_nowait()
            except:
                pass
            else:
                self.rx_q.task_done()
                header = item[1].min_id
                n_packet = len(item[1].payload)//4
                self._init_ch(header, n_packet)
                if args.logfile:
                    self._init_logfile(header)
            finally:
                sleep(1)
        
    def update(self):
        n = self.rx_q.qsize()
        buffer_header = np.zeros(n, dtype=np.ubyte)
        buffer_timestamp = np.zeros(n, dtype=datetime.datetime)
        buffer_data = np.zeros((n, self.parser.n_sig_per_ch*self.parser.n_ch))
        for i in range(n):
            try:
                item = self.rx_q.get_nowait()
            except:
                return
            timestamp = item[0]
            payload = self._process_payload(item[1].payload)
            buffer_timestamp[i] = timestamp
            buffer_data[i,:] = payload
            buffer_header[i] = item[1].min_id
            self.rx_q.task_done()
        sys.stdout.write('[' + str(n) + ']')
        if args.logfile:
            if args.is_triggered:
                is_logged = (buffer_header & (16).to_bytes(1, byteorder='big')[0]).astype(bool)
                if np.any(is_logged):
                    if not self._was_triggered:
                        self._start_time = buffer_timestamp[np.argmax(is_logged)]
                        self._was_triggered = True
                    sys.stdout.write('*')
                    self._update_logfile(np.vectorize(datetime.timedelta.total_seconds)(buffer_timestamp[is_logged] - self._start_time), buffer_data[is_logged])
                else:
                    self._was_triggered = False
            else:
                self._update_logfile(np.vectorize(datetime.timedelta.total_seconds)(buffer_timestamp - self._start_time), buffer_data)
        sys.stdout.write((''.join("\t%s: {:10.5e} %s" % (x[0], x[1]) for x in zip(self.parser.ylabel, self.parser.unit))).format(*np.average(buffer_data, axis=0)))
        sys.stdout.write('\n')
        if args.plot:
            self._update_plot_buffer(np.vectorize(lambda x : datetime.datetime.strftime(x, '%Y-%m-%dT%H%M%S.%f'))(buffer_timestamp), buffer_data)

    def _update_logfile(self, ts, data):
        with open(args.logfile, 'a') as f:
            np.savetxt(f, np.column_stack((ts, data)), delimiter='\t', fmt=self.parser.fmt_np)
            
    def _process_payload(self, payload):
        dt = np.dtype(np.int16)
        dt = dt.newbyteorder('>')
        payload = np.frombuffer(payload, dtype=dt)
        return self.parser.process(payload)

    def _update_plot_buffer(self, ts, data):
        self.lock.acquire(timeout=10)
        for i in range(len(ts)):
            self.x_plot.append(ts[i])
            self.y_plot.append([data[i][j] for j in range(self.parser.n_ch*self.parser.n_sig_per_ch)])
        self.lock.release()

    def _update_plot(self, i):
        self.lock.acquire(timeout=1)
        for i in range(self.parser.n_ch):
            if self.parser.n_ch==1:
                ch_ax = self.ax # in case self.ax is a 1-D array.
            else:
                ch_ax = self.ax[i]
            for j in range(self.parser.n_sig_per_ch):
                if self.parser.n_sig_per_ch==1:
                    ch_sig_ax = ch_ax
                else:
                    ch_sig_ax = ch_ax[j]
                ch_sig_ax.clear()
                ch_sig_ax.plot(np.asarray(self.x_plot), np.asarray(self.y_plot)[:,self.parser.n_sig_per_ch*i+j]) # Need thread lock on x_plot, y_plot
                ch_sig_ax.set_xticks(ch_sig_ax.get_xticks()[::10])
                ch_sig_ax.set_ylabel(self.parser.ylabel[self.parser.n_sig_per_ch*i+j] + " (" + self.parser.unit[self.parser.n_sig_per_ch*i+j] + ")")
        self.lock.release()
        self.fig.autofmt_xdate(rotation=45)
        #self.fig.fmt_xdate()
        plt.subplots_adjust(bottom=0.4)

    def animate(self):
        if args.plot:
            while not self.initialized: # Need to be initialized to obtain n_ch from the data packet header.
                sleep(PLOT_UPDATE_PERIOD)
            self.fig, self.ax = plt.subplots(self.parser.n_ch, self.parser.n_sig_per_ch, sharex='col', squeeze=True)
            self.anim = animation.FuncAnimation(self.fig, self._update_plot, interval=100)
            plt.show()
    
    def cleanup(self):  
        sys.stdout.write("\t=====CTRL-C received.=====\n")
        self.min.join()
        self.update_timer.stop()
        #self.rx_q.join()
        self.update()
        if args.plot:
            plt.close(self.fig)
        os._exit(0)

client = ReadSensor(args.port)

def cleanup_handler(signum, frame):
    signal.signal(signal.SIGINT, original_sigint)
    client.cleanup()  
    signal.signal(signal.SIGINT, cleanup_handler)

if __name__ == '__main__':
    original_sigint = signal.getsignal(signal.SIGINT)
    signal.signal(signal.SIGINT, cleanup_handler)
    client.start()
    client.animate()
    while True:
        sleep(1)