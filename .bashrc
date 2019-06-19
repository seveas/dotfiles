# Don't bother when in noninteractive mode
[ -z "$PS1" ] && return

# Sanity :)
shopt -s checkwinsize no_empty_cmd_completion histappend extglob globstar
if [ -e /usr/local/bin/gls ]; then
    unalias ls &>/dev/null
    for cmd in /usr/local/bin/g*; do
        cmdx=${cmd#/usr/local/bin/g}
        eval "$cmdx() { $cmd \"\$@\"; }"
    done
fi

# While initializing, make HOME point to where we are, this allows the trick in
# bashrc.d/sudo.sh to work
OLDHOME="$HOME"
HOME=$(dirname ${BASH_SOURCE[0]})

if [ -n "$SUDO_USER" ]; then
    alias not_with_sudo=return
else
    alias not_with_sudo=:
fi

# See if we need to update ourselves dotfiles
VCSH=
vcsh_update() {
    not_with_sudo
    unset vcsh
    which vcsh >/dev/null 2>&1 || alias vcsh=~/bin/vcsh

    # Don't try this if we're not connected
    if type nmcli &>/dev/null && [ $(nmcli n c) != 'full' ]; then return; fi

    for repo in $(vcsh list); do
        # If we have no upstream, don't bother
        vcsh $repo rev-parse --verify --quiet '@{u}' &>/dev/null || continue

        # Fetch at most once per hour
        if [ $(stat -c %Y "$(vcsh $repo rev-parse --git-dir)"/FETCH_HEAD) -lt $(( $(date +%s) - 3600 )) ]; then
            url=$(vcsh $repo config remote.origin.url)

            # Don't fetch via ssh unless we have an agent
            case "$url,$SSH_AUTH_SOCK" in
                http*) timeout 5 vcsh $repo fetch || echo "Unable to update dotfiles" >&2 ;;
                *,)    ;;
                *)     timeout 5 vcsh $repo fetch || echo "Unable to update dotfiles" >&2 ;;
            esac

        fi

        # Merge if it's a fast-forward
        if [ $(vcsh $repo rev-list --count '..@{u}') != 0 ]; then
            command vcsh $repo merge --ff --ff-only '@{u}'
        fi
        if [ -n "$(vcsh $repo status --porcelain)" ]; then
            VCSH="$VCSH*"
        fi
        if [ $(vcsh $repo rev-list --count '@{u}..') != 0 ]; then
            VCSH="$VCSH>"
        fi
    done
    if [ -n "$VCSH" ]; then
        VCSH="\[\033[31;1m\]$VCSH\[\033[0m\] "
    fi
    unalias vcsh 2>/dev/null
}

# The pre phase sets up proxies
phase=pre
. ~/.bashrc.d/local/mine.sh

# Update ourselves early
vcsh_update
unset vcsh_update

# And now the actual dotfiles
for f in ~/.bashrc.d/*.sh; do
    . $f
done
phase=post
. ~/.bashrc.d/local/mine.sh
HOME="$OLDHOME"
