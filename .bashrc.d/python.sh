export PYTHONPATH=/home/dennis/lib/python
export PYTHONSTARTUP=$HOME/.startup.py
from() { expect -c "spawn -noecho python
expect \">>> \"
send \"from $*\r\"
interact +++ return"; }
import() { expect -c "spawn -noecho python
expect \">>> \"
send \"import $*\r\"
interact +++ return"; }
