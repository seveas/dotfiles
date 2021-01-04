(ssh-add -l || /usr/bin/ssh-add -K )&>/dev/null
. /usr/local/etc/bash_completion
printf() { if [ $1 = "-v" ]; then command printf "$@"; else gprintf "$@"; fi; }
mkdir -p ~/.shc
