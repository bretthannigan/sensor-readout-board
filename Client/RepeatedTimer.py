from threading import Timer
from time import sleep

# From: https://stackoverflow.com/a/38317060
class RepeatedTimer(object):
    def __init__(self, interval, function, *args, **kwargs):
        self._timer = None
        self.interval = interval
        self.function = function
        self.args = args
        self.kwargs = kwargs
        self.is_running = False
        self._is_cancelled = False

    def _run(self):
        self.is_running = False
        self.function(*self.args, **self.kwargs)
        self.start()
        
    def start(self):
        if (not self.is_running) and (not self._is_cancelled):
            self._timer = Timer(self.interval, self._run)
            self._timer.daemon = True
            self._timer.start()
            self.is_running = True
        return

    def stop(self):
        self._timer.cancel()
        self._is_cancelled = True