if [ -e ~/.dotfiles ]; then
    PATH=$PATH:~/.dotfiles/bin
fi
if [ $(stat -c %Y $(vcsh dotfiles rev-parse --git-dir)) -lt $(( $(date +%s) - 3600 )) ]; then
    if ssh-add -l >/dev/null 2>&1; then
        vcsh dotfiles fetch
    fi
fi
if [ -n "$(vcsh dotfiles status --porcelain)" ]; then
    VCSH="*"
fi
if [ $(vcsh dotfiles rev-list --count '@{u}..') != 0 ]; then
    VCSH="$VCSH>"
fi
if [ -n "$VCSH" ]; then
    VCSH="\033[31;1m$VCSH\033[0m "
else
    if [ $(vcsh dotfiles rev-list --count '..@{u}') != 0 ]; then
        vcsh dotfiles merge --ff --ff-only '@{u}'
    fi
fi
