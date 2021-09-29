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

import PollMIN
import RepeatedTimer
import argparse

# Command line parameters
parser = argparse.ArgumentParser(description='Logging utility for MENRVA sensor readout board.')
parser.add_argument('--port', dest='port', action='store', default="COM14", help='Serial port for readout board.')
parser.add_argument('--logfile', dest='logfile', action='store', default=datetime.datetime.now().strftime("Log_%Y-%m-%dT%H%M%S.csv"), help='Custom log file name.')
parser.add_argument('--plot', dest='plot', action='store_true', default=True, help='Turn on/off plotting data (default=on)')
parser.add_argument('--mode', dest='mode', action='store', choices=['raw', 'iq', 'magphase', 'RCparallel', 'RCparallel'], default='RCseries', help='Impedance calculation mode.')
parser.add_argument('--gain', dest='gain', action='store', type=float, choices=[1e-2, 1e-3, 1e-1, 1e-5], default=1e-3, help='Gain setting selected with readout board jumper.')
parser.add_argument('--exc_amp', dest='excitation_amplitude', action='store', default=0.5, help='Excitation sine wave scaling factor.')
args = parser.parse_args()

class ReadSensor:

    __version__ = '0.1'
    UPDATE_PERIOD = 1
    dtype = [('Timestamp', (np.str_, 24)), ('Ch0', np.double), ('Ch1', np.double), ('Ch2', np.double), ('Ch3', np.double)]
    excitation_frequency = 1556.0 # Hz

    def __init__(self, port):
        self.port = port
        sys.stdout.write('MENRVA Sensor Readout Client v' + self.__version__ + '\n')
        sys.stdout.write('Listening on port ' + args.port + '\n')
        self.x_plot = deque(maxlen=50)
        self.y_plot = deque(maxlen=50)
        self.initialized = False
        
    def start(self):
        self.rx_q = queue.Queue(1024)
        self.min = PollMIN.PollMIN(self.port, self.rx_q)
        self.min.start()
        self.update_timer = RepeatedTimer.RepeatedTimer(self.UPDATE_PERIOD, self.update)
        if args.mode == 'raw':
            self.dtype = [('Timestamp', (np.str_, 24)), ('i_0', np.int16), ('q_0', np.int16), ('i_1', np.int16), ('q_1', np.int16), ('i_2', np.int16), ('q_2', np.int16), ('i_3', np.int16), ('q_3', np.int16)]
            self.fmt = ['%s', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i']
            self.ylabel = ['Ch0 I (counts)', 'Ch0 Q (counts)', 'Ch1 I (counts)', 'Ch1 Q (counts)', 'Ch2 I (counts)', 'Ch2 Q (counts)', 'Ch3 I (counts)', 'Ch3 Q (counts)']
        elif args.mode == 'iq':
            self.dtype = [('Timestamp', (np.str_, 24)), ('i_0', np.double), ('q_0', np.double), ('i_1', np.double), ('q_1', np.double), ('i_2', np.double), ('q_2', np.double), ('i_3', np.double), ('q_3', np.double)]
            self.fmt = ['%s', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f']
            self.ylabel = ['Ch0 I', 'Ch0 Q', 'Ch1 I', 'Ch1 Q', 'Ch2 I', 'Ch2 Q', 'Ch3 I', 'Ch3 Q']
        elif args.mode == 'magphase':
            self.dtype = [('Timestamp', (np.str_, 24)), ('mag_0', np.double), ('phase_0', np.double), ('mag_1', np.double), ('phase_1', np.double), ('mag_2', np.double), ('phase_2', np.double), ('mag_3', np.double), ('phase_3', np.double)]
            self.fmt = ['%s', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f']
            self.ylabel = ['Ch0 mag. (dB)', 'Ch0 phase (deg)', 'Ch1 mag. (dB)', 'Ch1 phase (deg)', 'Ch2 mag. (dB)', 'Ch2 phase (deg)', 'Ch3 mag. (dB)', 'Ch3 phase (deg)']
        elif args.mode == 'RCseries':
            self.dtype = [('Timestamp', (np.str_, 24)), ('R_0', np.double), ('C_0', np.double), ('R_1', np.double), ('C_1', np.double), ('R_2', np.double), ('C_2', np.double), ('R_3', np.double), ('C_3', np.double)]
            self.fmt = ['%s', '%e', '%e', '%e', '%e', '%e', '%e', '%e', '%e']
            self.ylabel = ['Ch0 R (ohm)', 'Ch0 C (F)', 'Ch1 R (ohm)', 'Ch1 C (F)', 'Ch2 R (ohm)', 'Ch2 C (F)', 'Ch3 R (ohm)', 'Ch3 C (F)']
        elif args.mode == 'RCparallel':
            self.dtype = [('Timestamp', (np.str_, 24)), ('R_0', np.double), ('C_0', np.double), ('R_1', np.double), ('C_1', np.double), ('R_2', np.double), ('C_2', np.double), ('R_3', np.double), ('C_3', np.double)]
            self.fmt = ['%s', '%e', '%e', '%e', '%e', '%e', '%e', '%e', '%e']
            self.ylabel = ['Ch0 R (ohm)', 'Ch0 C (F)', 'Ch1 R (ohm)', 'Ch1 C (F)', 'Ch2 R (ohm)', 'Ch2 C (F)', 'Ch3 R (ohm)', 'Ch3 C (F)']

    def _init_ch(self, hdr, n):
        self.dtype = self.dtype[0:(n+1)]
        self.fmt = self.fmt[0:(n+1)]
        self.n_ch = n//2
        self.initialized = True

    def _init_logfile(self, hdr):
        log_header = self.dtype[0][0]
        for i in range(self.n_ch*2):
            log_header = log_header + ',' + self.dtype[i+1][0]
        log_header = log_header + '\n'
        with open(args.logfile, 'xt') as f:
            f.write(log_header)
        
    def update(self):
        n = self.rx_q.qsize()
        print(n)
        i = 0
        buffer = np.zeros(n, dtype=self.dtype)
        for i in range(n):
            item = self.rx_q.get_nowait()
            timestamp = item[0]
            if not self.initialized:
                header = item[1].min_id
                n_packet = len(item[1].payload)//2
                self._init_ch(header, n_packet)
                if args.logfile:
                    self._init_logfile(header)
                    buffer = np.zeros(n, dtype=self.dtype)
            payload = self._process_payload(item[1].payload, mode=args.mode)
            buffer[i] = (timestamp.strftime("%Y-%m-%dT%H%M%S.%f"), *payload)
            self.rx_q.task_done()
        #print(buffer)
        if args.logfile and self.initialized:
            self._update_logfile(buffer)
        if args.plot and self.initialized:
            self._update_plot_buffer(buffer)

    def _update_logfile(self, buf):
        with open(args.logfile, 'a') as f:
            np.savetxt(f, buf, delimiter=',', fmt=self.fmt)
            
    def _process_payload(self, payload, mode="iq"):
        dt = np.dtype(np.int16)
        dt = dt.newbyteorder('>')
        payload = np.frombuffer(payload, dtype=dt)
        if mode=="raw":
            return payload
        MAX_INPUT_VALUE = np.iinfo(dt).max # Maximum value of input (16-bit integer).
        iq = payload/((MAX_INPUT_VALUE//2)*args.excitation_amplitude*args.gain)
        if mode=="iq":
            return iq
        elif mode=="magphase":
            iq_split = np.split(iq, len(iq)//2)
            iq_complex = np.array([np.complex(*x) for x in iq_split])
            mag = np.abs(iq_complex)
            phase = np.angle(iq_complex)
            mag_phase = np.empty((mag.size + phase.size))
            mag_phase[0::2] = 20.0*np.log10(2.0*mag)
            mag_phase[1::2] = -2.0*(180.0/np.pi)*phase
            return mag_phase
        elif mode=="RCseries":
            r = iq[0::2]
            c = -1.0/(2.0*np.pi*self.excitation_frequency*iq[1::2])
            rc = np.empty((r.size + c.size))
            rc[0::2] = r
            rc[1::2] = c
            return rc
        elif mode=="RCparallel":
            i2q2_split = np.sum(np.split(iq**2, len(iq)//2), axis=1)
            r = i2q2_split/iq[0::2]
            c = -1.0*iq[1::2]/(2.0*np.pi*self.excitation_frequency*i2q2_split)
            rc = np.empty((r.size + c.size))
            rc[0::2] = r
            rc[1::2] = c
            return rc
        else:
            pass

    def _update_plot_buffer(self, buf):
        for i in range(len(buf)):
            self.x_plot.append(buf[i]['Timestamp'])
            self.y_plot.append([buf[i][j+1] for j in range(self.n_ch*2)])

    def _update_plot(self, i):
        for i in range(self.n_ch*2):
            self.ax[i].clear()
            self.ax[i].plot(np.asarray(self.x_plot), np.asarray(self.y_plot)[:,i])
            self.ax[i].set_xticks(self.ax[i].get_xticks()[::5])
            self.ax[i].set_ylabel(self.ylabel[i])
        self.fig.autofmt_xdate(rotation=45)
        plt.subplots_adjust(bottom=0.4)

    def animate(self):
        if args.plot:
            while not self.initialized: # Need to be initialized to obtain n_ch from the data packet header.
                sleep(0.1)
            self.fig, self.ax = plt.subplots(self.n_ch, 2, sharex='col', squeeze=True)
            self.anim = animation.FuncAnimation(self.fig, self._update_plot, interval=100)
            plt.show()
    
    def cleanup(self):  
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