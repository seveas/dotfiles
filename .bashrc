# Don't bother when in noninteractive mode
[ -z "$PS1" ] && return

# Sanity :)
shopt -s checkwinsize no_empty_cmd_completion histappend extglob globstar

# While initializing, make HOME point to where we are, this allows the trick in
# bashrc.d/sudo.sh to work
OLDHOME="$HOME"
HOME=$(dirname ${BASH_SOURCE[0]})

if [ -n "$SUDO_USER" ]; then
    alias not_with_sudo=return
else
    alias not_with_sudo=:
fi

phase=pre
. ~/.bashrc.d/local/mine.sh
for f in ~/.bashrc.d/*.sh; do
    . $f
done
phase=post
. ~/.bashrc.d/local/mine.sh
HOME="$OLDHOME"
