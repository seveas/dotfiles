# Don't bother when in noninteractive mode
[ -z "$PS1" ] && return

# Sanity :)
shopt -s checkwinsize no_empty_cmd_completion histappend

# While initializing, make HOME point to where we are, this allows the trick in
# bashrc.d/sudo.sh to work
OLDHOME="$HOME"
HOME=$(dirname ${BASH_SOURCE[0]})
if [ -d ~/.bashrc.d ]; then
    for f in ~/.bashrc.d/*.sh; do
        . $f
    done
fi

if [ -e ~/.bashrc.d/local/mine.sh ]; then
    . ~/.bashrc.d/local/mine.sh
fi
HOME="$OLDHOME"
