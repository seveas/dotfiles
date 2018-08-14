#!/bin/bash -- to trick vim...

not_with_sudo

# Make sure the path for controlfiles exists
if [ -e ~/.ssh/control ] && [ ! -e ~/.shc ]; then
  mv ~/.ssh/control ~/.shc
else
  mkdir -p -m700 ~/.shc
fi

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
        y=${x/-cp1-prd*/}
        if ! type $y > /dev/null 2>&1; then
            alias $y="ssh $x"
        fi
    done
fi

