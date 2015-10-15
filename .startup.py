import atexit
import readline
import datetime, os, sys, re, time, socket
from pprint import pprint

sys.displayhook = pprint

histfile = os.path.join(os.environ["HOME"], ".python_history")
try:
    readline.read_history_file(histfile)
except IOError:
    pass
atexit.register(readline.write_history_file, histfile)
del histfile, atexit, readline
