#!/bin/bash -- to trick vim...

not_with_sudo

# Make sure the path for controlfiles exists
mkdir -p -m700 ~/.ssh/control

# Steal SSH agent unless this one works
if ! $(ssh-add -l >/dev/null 2>&1); then
    for f in /tmp/ssh-*; do
        if [[ -r $f ]]; then
            SSH_AUTH_SOCK=$f/$(ls $f)
            break
        fi
    done
fi

# Make lots of aliases
if [ -d ~/.ssh ]; then
    if [ ! -e ~/.ssh/config ]; then . ~/.bashrc.d/templates.sh; fi
    if [ ! -e ~/.ssh/known_hosts ]; then touch ~/.ssh/known_hosts; fi
    for x in `(sed -e 's/[, ].*//' ~/.ssh/known_hosts; awk '/^Host [^*?]+$/{print $2}' ~/.ssh/config) | sort -r`; do
        # Don't override commands
        if ! type $x > /dev/null 2>&1; then
            alias $x="ssh $x"
        fi
        y=${x/.*/}
        if ! type $y > /dev/null 2>&1; then
            alias $y="ssh $x"
        fi
    done
fi

# Wrap ssh for yubikeys
if [ -e ~/.ssh/2fa_hosts ]; then
    ssh() {
        # Parse the command line to extract the hostname we connect to
        opts=46AaCcfgKkMNnqsTtVvXxYyb:c:D:E:e:F:I:i:J:L:l:m:O:o:p:Q:R:S:W:w
        args=$(getopt $opts $*)
        if [ $? = 0 ]; then
            (
                set -- $args
                for i; do
                    if [ "$i" = '--' ]; then shift; break; fi
                    shift;
                done
                grep -q "^$1$" ~/.ssh/2fa_hosts && osascript -e 'tell application "yubiswitch" to KeyOn'
            )
        fi
        command ssh "$@"
    }
fi
