export PYTHONPATH=/home/dennis/lib/python
export PYTHONSTARTUP=$HOME/.startup.py
PYTHONS="
    /usr/bin/python3
    /bin/python3
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

which pip3 &>/dev/null || alias pip3='python3 -mpip'
