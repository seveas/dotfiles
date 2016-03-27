#!/bin/bash -- to trick vim...

# Use funky ssh by default
alias ssh=~/bin/my_ssh

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
    if [ ! -e ~/.ssh/config ]; then touch ~/.ssh/config; fi
    if [ ! -e ~/.ssh/known_hosts ]; then touch ~/.ssh/known_hosts; fi
    for x in `(sed -e 's/[, ].*//' ~/.ssh/known_hosts; awk '/^Host [^*?]+$/{print $2}' ~/.ssh/config) | grep -v lom.booking.com | sort -r`; do
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

if [ -e /etc/hosts.booking ]; then
    complete -W "$(</etc/hosts.booking)" ssh
fi
