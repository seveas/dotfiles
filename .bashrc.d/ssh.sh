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
    set +m
    shopt -s lastpipe
    grep '^Host' ~/.ssh/config | tac | while read key value; do
        if [ $key = "HostName" ]; then
            last_host=$value
        else
            for host in $value; do
                hostname=${last_host:-$host}
                case $host in
                    *"*"*)
                        ;;
                    *.*)
                        alias $host="ssh $hostname"
                        alias ${host/.*/}="ssh $hostname"
                        ;;
                    *)
                        alias $host="ssh $hostname"
                        ;;
                  esac
            done
            unset last_host
        fi
    done
    shopt -u lastpipe
    set -m
fi
