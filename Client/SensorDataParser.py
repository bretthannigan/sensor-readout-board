import sys
import numpy as np
import sklearn
import pickle


class SensorDataParserRaw:
    PREFIX = ["I", "Q"]
    UNIT = ["counts", "counts"]
    _DATATYPE = np.int16

    def __init__(self, n_ch, n_sig=2, exc_amp=1., exc_freq=0., scaling=1.):
        self._n_ch = n_ch
        self._n_sig_per_ch = n_sig
        self._excitation_amplitude = exc_amp
        self._excitation_frequency = exc_freq
        self._scaling = scaling
        self._dtype = [(self.PREFIX[j] + "_" + str(i), self._DATATYPE) for i in range(self._n_ch) for j in range(self._n_sig_per_ch)]
        self._fmt = ['s'] + ['i' for _ in range(self._n_sig_per_ch*self._n_sig_per_ch)]
        self._ylabel = ['Ch' + str(i) + "_" + self.PREFIX[j] for i in range(self._n_ch) for j in range(self._n_sig_per_ch)]
        self._unit = self.UNIT * self._n_ch

    def process(self, payload):
        return payload
        sklearn.ensemble.RandomForestRegressor().predict_single

    @property
    def n_ch(self):
        return self._n_ch

    @property
    def n_sig_per_ch(self):
        return self._n_sig_per_ch

    @property
    def dtype(self):
        return self._dtype

    @property
    def fmt(self):
        return self._fmt

    @property
    def fmt_np(self):
        return ['%' + s for s in self._fmt]

    @property
    def unit(self):
        return self._unit

    @property
    def ylabel(self):
        return self._ylabel

# class SensorDataParserIQ(SensorDataParserRaw):
#     PREFIX = ["I", "Q"]
#     UNIT = ["", ""]
#     _DATATYPE = np.double
#     _MAX_INPUT_VALUE = np.iinfo(np.dtype(np.int16)).max # Maximum 16-bit integer.

#     def __init__(self, n_ch, exc_amp=1., exc_freq=0., scaling=1.):
#         super().__init__(n_ch, exc_amp, exc_freq, scaling)
#         self._fmt = ['s'] + ['10.5e' for _ in range(2*self.n_ch)]

#     def process(self, payload):
#         return payload/((self._MAX_INPUT_VALUE//2)*self._excitation_amplitude*self._scaling)

class SensorDataParserIQ(SensorDataParserRaw):
    PREFIX = ["I", "Q"]
    UNIT = ["", ""]
    _DATATYPE = np.double
    _MAX_INPUT_VALUE = np.iinfo(np.dtype(np.int16)).max # Maximum 16-bit integer.

    def __init__(self, n_ch, n_sig=2, exc_amp=1., exc_freq=[0.], scaling=1., is_calibration=False):
        super().__init__(n_ch, n_sig=n_sig, exc_amp=exc_amp, exc_freq=exc_freq, scaling=scaling)
        self._fmt = ['s'] + ['10.5e' for _ in range(self._n_sig_per_ch*self.n_ch)]
        self._is_calibration = is_calibration
        self._cal_data = np.loadtxt('cal.csv', delimiter=',', skiprows=1)

    def calibrate(self, x):
        y = np.zeros(x.shape)
        for i in range(len(x)//2):
            i_freq = np.where(self._cal_data[:,0]==self._excitation_frequency[i])
            y[2*i] = x[2*i]*self._cal_data[i_freq,1] + self._cal_data[i_freq,2] # I channel
            if x[2*i]<x[2*i+1]: # Q channel
                y[2*i+1] = x[2*i+1]*self._cal_data[i_freq,3] + self._cal_data[i_freq,4]
            else:
                y[2*i+1] = x[2*i+1]*self._cal_data[i_freq,5] + self._cal_data[i_freq,6]
        return y

    def process(self, payload):
        payload = payload/((self._MAX_INPUT_VALUE//2)*self._excitation_amplitude*self._scaling)
        if self._is_calibration:
            payload = self.calibrate(payload)
        return payload

class SensorDataParserModel(SensorDataParserIQ):
    PREFIX = ["Strain"]
    UNIT = ["%"]
    
    def __init__(self, n_ch, exc_amp=1., exc_freq=[0.], scaling=1., is_calibration=False, model_path='model.sav'):
        super().__init__(n_ch, n_sig=1, exc_amp=exc_amp, exc_freq=exc_freq, scaling=scaling, is_calibration=is_calibration)
        self._fmt = ['s'] + ['10.5f' for _ in range(self._n_sig_per_ch*self.n_ch)]
        sys.stdout.write('\t=====Loading model from: ' + model_path + '=====\n')
        self._model = pickle.load(open(model_path, 'rb'))
        sys.stdout.write('\t\t' + str(self._model) + '\n')
    
    def process(self, payload):
        iq = super().process(payload)
        percent_strain = self._model.predict(np.concatenate((iq[0::2], iq[1::2])).reshape(-1, len(iq)))*100.0
        return percent_strain

class SensorDataParserMagPhase(SensorDataParserIQ):
    PREFIX = ["Mag", "Phase"]
    UNIT = ["dB", "deg"]

    def __init__(self, n_ch, exc_amp=1., exc_freq=[0.], scaling=1., is_calibration=False):
        super().__init__(n_ch, exc_amp=exc_amp, exc_freq=exc_freq, scaling=scaling, is_calibration=is_calibration)

    def process(self, payload):
        iq = super().process(payload)
        iq_split = np.split(iq, len(iq)//2)
        iq_complex = np.array([np.complex(*x) for x in iq_split])
        mag = np.abs(iq_complex)
        phase = np.angle(iq_complex)
        mag_phase = np.empty((mag.size + phase.size))
        mag_phase[0::2] = 20.0*np.log10(2.0*mag)
        mag_phase[1::2] = -1.0*(180.0/np.pi)*phase
        return mag_phase

class SensorDataParserRCSeries(SensorDataParserIQ):
    PREFIX = ["R", "C"]
    UNIT = ["\u03A9", "F"]

    def __init__(self, n_ch, exc_amp=1., exc_freq=[0.], scaling=1., is_calibration=False):
        super().__init__(n_ch, exc_amp=exc_amp, exc_freq=exc_freq, scaling=scaling, is_calibration=is_calibration)

    def process(self, payload):
        iq = super().process(payload)
        r = iq[0::2]
        c = -1.0/(2.0*np.pi*self._excitation_frequency*iq[1::2])
        rc = np.empty((r.size + c.size))
        rc [0::2] = r
        rc [1::2] = c
        return rc

class SensorDataParserRCParallel(SensorDataParserIQ):
    PREFIX = ["R", "C"]
    UNIT = ["\u03A9", "F"]

    def __init__(self, n_ch, exc_amp=1., exc_freq=[0.], scaling=1., is_calibration=False):
        super().__init__(n_ch, exc_amp=exc_amp, exc_freq=exc_freq, scaling=scaling, is_calibration=is_calibration)

    def process(self, payload):
        iq = super().process(payload)
        i2q2_split = np.sum(np.split(iq**2, len(iq)//2), axis=1)
        r = i2q2_split/iq[0::2]
        c = -1.0*iq[1::2]/(2.0*np.pi*self._excitation_frequency*i2q2_split)
        rc = np.empty((r.size + c.size))
        rc[0::2] = r
        rc[1::2] = c
        return rc