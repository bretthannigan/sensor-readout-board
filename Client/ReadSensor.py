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
parser.add_argument('--port', dest='port', action='store', default="COM8", help='Serial port for readout board.')
parser.add_argument('--logfile', dest='logfile', action='store', default=datetime.datetime.now().strftime("Log_%Y-%m-%dT%H%M%S.csv"), help='Custom log file name.')
parser.add_argument('--plot', dest='plot', action='store_true', default=True, help='Turn on/off plotting data (default=on)')
parser.add_argument('--mode', dest='mode', action='store', choices=['raw', 'iq', 'magphase', 'RCseries', 'RCparallel'], default='RCparallel', help='Impedance calculation mode.')
parser.add_argument('--gain', dest='gain', action='store', type=float, choices=[1e-2, 1e-3, 1e-1, 1e-5], default=1e-4, help='Gain setting selected with readout board jumper.')
parser.add_argument('--exc_amp', dest='excitation_amplitude', action='store', default=0.33, help='Excitation sine wave scaling factor.')
parser.add_argument('--trig', dest='is_triggered', action='store_true', default=True, help='Enable triggering of logging from the device.')
args = parser.parse_args()

class ReadSensor:

    __version__ = '0.2'
    __board_rev__ = 'B'
    UPDATE_PERIOD = 1
    dtype = [('Timestamp', (np.str_, 24)), ('Ch0', np.double), ('Ch1', np.double), ('Ch2', np.double), ('Ch3', np.double)]
    #excitation_frequency = np.array([1556.0, 3113.0, 6226.0, 12451.0, 24902.0, 49805.0, 99609.0])  # Hz
    #excitation_frequency = np.array([49805.0])  # Hz
    excitation_frequency = np.array([99609.0, 49805.0, 24902.0, 12451.0])  # Hz
    lock = threading.Lock()

    def __init__(self, port):
        self.splash()
        self.port = port
        sys.stdout.write('\t=====Listening on port: ' + args.port + '.=====\n')
        self.x_plot = deque(maxlen=100)
        self.y_plot = deque(maxlen=100)
        self.initialized = False

    def splash(self):
        sys.stdout.write('\n')
        with open('ETH.txt', 'r') as f:
            sys.stdout.write(f.read())
        sys.stdout.write(' BMHT Sensor Readout Client v' + self.__version__ + ' (board revision ' + self.__board_rev__ + ')' '\n\n')

    def start(self):
        self.rx_q = queue.Queue(1024)
        self.min = PollMIN.PollMIN(self.port, self.rx_q)
        self.min.start()
        self.update_timer = RepeatedTimer.RepeatedTimer(self.UPDATE_PERIOD, self.update)

    def _init_ch(self, hdr, n):
        if args.mode == 'raw':
            self.parser = SensorDataParserRaw(n, args.excitation_amplitude, self.excitation_frequency, args.gain)
        elif args.mode == 'iq':
            self.parser = SensorDataParserIQ(n, args.excitation_amplitude, self.excitation_frequency, args.gain)
        elif args.mode == 'magphase':
            self.parser = SensorDataParserMagPhase(n, args.excitation_amplitude, self.excitation_frequency, args.gain)
        elif args.mode == 'RCseries':
            self.parser = SensorDataParserRCSeries(n, args.excitation_amplitude, self.excitation_frequency, args.gain)
        elif args.mode == 'RCparallel':
            self.parser = SensorDataParserRCParallel(n, args.excitation_amplitude, self.excitation_frequency, args.gain)
        self.initialized = True
        sys.stdout.write('\t=====Detected ' + str(n) + ' channel(s).=====\n')

    def _init_logfile(self, hdr):
        log_header = self.parser.dtype[0][0]
        for i in range(self.parser.n_ch*2):
            log_header = log_header + ',' + self.parser.dtype[i+1][0]
        log_header = log_header + '\n'
        with open(args.logfile, 'xt') as f:
            f.write(log_header)
        
    def update(self):
        n = self.rx_q.qsize()
        i = 0
        if self.initialized:
            buffer_data = np.zeros(n, dtype=self.parser.dtype)
            buffer_header = np.zeros(n, dtype=np.ubyte)
        for i in range(n):
            item = self.rx_q.get_nowait()
            timestamp = item[0]
            if not self.initialized:
                header = item[1].min_id
                n_packet = len(item[1].payload)//4
                self._init_ch(header, n_packet)
                buffer_data = np.zeros(n, dtype=self.parser.dtype)
                buffer_header = np.zeros(n, dtype=np.ubyte)
                if args.logfile:
                    self._init_logfile(header)
            payload = self._process_payload(item[1].payload, mode=args.mode)
            buffer_data[i] = (timestamp.strftime("%Y-%m-%dT%H%M%S.%f"), *payload)
            buffer_header[i] = item[1].min_id
            self.rx_q.task_done()
        if self.initialized:
            sys.stdout.write('[' + str(n) + ']')
            for i in range(2*self.parser.n_ch):
                sys.stdout.write(("\t" + self.parser.ylabel[i] + ": {:10.5e} " + self.parser.unit[i]).format(np.average([x[i+1] for _, x in enumerate(buffer_data)])))
            sys.stdout.write('\n')
        if args.logfile and self.initialized:
            if args.is_triggered:
                is_logged = (buffer_header & (16).to_bytes(1, byteorder='big')[0]).astype(bool)
                if np.any(is_logged):
                    self._update_logfile(buffer_data[is_logged])
            else:
                self._update_logfile(buffer_data)
        if args.plot and self.initialized:
            self._update_plot_buffer(buffer_data)

    def _update_logfile(self, buf):
        with open(args.logfile, 'a') as f:
            np.savetxt(f, buf, delimiter=',', fmt=self.parser.fmt_np)
            
    def _process_payload(self, payload, mode="iq"):
        dt = np.dtype(np.int16)
        dt = dt.newbyteorder('>')
        payload = np.frombuffer(payload, dtype=dt)
        return self.parser.process(payload)

    def _update_plot_buffer(self, buf):
        self.lock.acquire()
        for i in range(len(buf)):
            self.x_plot.append(buf[i]['Timestamp'])
            self.y_plot.append([buf[i][j+1] for j in range(self.parser.n_ch*2)])
        self.lock.release()

    def _update_plot(self, i):
        self.lock.acquire(timeout=2)
        for i in range(self.parser.n_ch):
            if self.parser.n_ch==1:
                ch_ax = self.ax # in case self.ax is a 1-D array.
            else:
                ch_ax = self.ax[i]
            for j in range(2):
                ch_ax[j].clear()
                ch_ax[j].plot(np.asarray(self.x_plot), np.asarray(self.y_plot)[:,2*i+j]) # Need thread lock on x_plot, y_plot
                ch_ax[j].set_xticks(ch_ax[j].get_xticks()[::5])
                ch_ax[j].set_ylabel(self.parser.ylabel[2*i+j] + " (" + self.parser.unit[2*i+j] + ")")
        self.lock.release()
        self.fig.autofmt_xdate(rotation=45)
        #self.fig.fmt_xdate()
        plt.subplots_adjust(bottom=0.4)

    def animate(self):
        if args.plot:
            while not self.initialized: # Need to be initialized to obtain n_ch from the data packet header.
                sleep(0.1)
            self.fig, self.ax = plt.subplots(self.parser.n_ch, 2, sharex='col', squeeze=True)
            self.anim = animation.FuncAnimation(self.fig, self._update_plot, interval=100)
            plt.show()
    
    def cleanup(self):  
        sys.stdout.write("\t=====CTRL-C received.=====\n")
        self.min.join()
        self.update_timer.stop()
        self.update()
        self.rx_q.join()
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