export PYTHONPATH=/home/dennis/git/sysadmin:/home/dennis/git_tree/sysadmin
export PYTHONSTARTUP=$HOME/.startup.py
from() { expect -c "spawn -noecho python
expect \">>> \"
send \"from $*\r\"
interact +++ return"; }
import() { expect -c "spawn -noecho python
expect \">>> \"
send \"import $*\r\"
interact +++ return"; }
