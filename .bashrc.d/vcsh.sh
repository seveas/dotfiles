not_with_sudo

if [ -e ~/.dotfiles ]; then
    PATH=$PATH:~/.dotfiles/bin
fi

unset vcsh
if [ $(stat -c %Y "$(vcsh dotfiles rev-parse --git-dir)"/FETCH_HEAD) -lt $(( $(date +%s) - 3600 )) ]; then
    if ssh-add -l >/dev/null 2>&1; then
        if /sbin/route -n | grep -q UG; then
            vcsh dotfiles fetch
        fi
    fi
fi
VCSH=
vcsh() {
    command vcsh "$@"
    VCSH=
    for repo in $(command vcsh list); do
        if [ -n "$(command vcsh $repo status --porcelain)" ]; then
            VCSH="$VCSH*"
        fi
        if [ -n "$(command vcsh $repo rev-parse '@{u}' 2>/dev/null)" ] && [ $(command vcsh $repo rev-list --count '@{u}..') != 0 ]; then
            VCSH="$VCSH>"
        fi
    done
    if [ -n "$VCSH" ]; then
        VCSH="\[\033[31;1m\]$VCSH\[\033[0m\] "
    fi
}
vcsh list > /dev/null
if [ -n "$VCSH" ]; then
    for repo in $(command vcsh list); do
        if [ $(command vcsh dotfiles rev-list --count '..@{u}') != 0 ]; then
            command vcsh $repo merge --ff --ff-only '@{u}'
        fi
    done
fi
