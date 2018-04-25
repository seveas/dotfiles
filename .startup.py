from __future__ import division, print_function, unicode_literals, absolute_import
import atexit
import readline
import datetime, os, sys, re, time, socket
from pprint import pprint
try:
    from whelk import shell
except ImportError:
    pass

def displayhook(value):
    pprint(value)
    __builtins__._ = value
sys.displayhook = displayhook

def excepthook(typ, val, tb):
    sys.__excepthook__(typ, val, tb)
    import debugme
sys.excepthook = excepthook

histfile = os.path.join(os.environ["HOME"], ".python_history")
try:
    readline.read_history_file(histfile)
except IOError:
    pass
atexit.register(readline.write_history_file, histfile)
del histfile, atexit, readline
