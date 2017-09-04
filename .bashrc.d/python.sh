export PYTHONPATH=/home/dennis/lib/python
export PYTHONSTARTUP=$HOME/.startup.py
PYTHONS="
    /usr/local/bin/blue-python3.5
    /usr/local/bin/blue-python3.4
    /usr/local/bin/blue-python3.6
    /usr/bin/python3
    /bin/python3
    /usr/local/bin/blue-python2.7
    /usr/bin/python2
    /bin/python2
    /usr/bin/python
    /bin/python
"
python() {(
    for py in $PYTHONS; do
        test -x $py && exec $py "$@"
    done
)}
