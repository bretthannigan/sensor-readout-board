from struct import unpack
from time import sleep, time
from logging import DEBUG
from min.host.min import ThreadsafeTransportMINSerialHandler

import datetime
import threading
import subprocess
import queue

class PollMIN(threading.Thread):
    def __init__(self, min_port, rx_q):
        super(PollMIN, self).__init__()
        self.min_handler = ThreadsafeTransportMINSerialHandler(port=min_port, loglevel=DEBUG)
        self.rx_q = rx_q
        self.stoprequest = threading.Event()

    def run(self):
        while not self.stoprequest.isSet():
            try:
                for packet in self.min_handler.poll():
                    self.rx_q.put((datetime.datetime.now(), packet))
            except queue.Empty:
                continue

    def join(self, timeout=1):
        self.stoprequest.set()
        super(PollMIN, self).join(timeout)