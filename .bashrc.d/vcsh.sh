not_with_sudo

if [ -e ~/.dotfiles ]; then
    PATH=$PATH:~/.dotfiles/bin
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
