(ssh-add -l || ssh-add -K )&>/dev/null
. /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
. /usr/local/etc/bash_completion
printf() { if [ $1 = "-v" ]; then command printf "$@"; else gprintf "$@"; fi; }
