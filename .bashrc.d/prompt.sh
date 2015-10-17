if declare -f __git_ps1 > /dev/null; then
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUPSTREAM=auto
    GIT_PS1_DESCRIBE_STYLE=branch
    GIT_PS1_SHOWCOLORHINTS=1
    PS1_GIT=1
fi

__prompt() {
    history -a
    case "$TERM" in
    xterm*|rxvt*)
        echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/\~}\007"
        ;;
    esac
    if [ -n "$OLDPWD" ]; then
        if declare -f "$CD_COMMAND" >/dev/null; then
            $CD_COMMAND
            OLDPWD=
        fi
    fi
    if [ $USER  == 'root' ]; then
        USERX="\033[31;1m$USER\033[0m"
        PROMPT='# '
    else
        USERX=$USER
        PROMPT='$ '
    fi
    PS1="$USERX@$HOSTNAME:${PWD/$HOME/\~}"
    if [ "$PS1_GIT" == 1 ]; then
        __git_ps1 "$PS1" "$PROMPT"
    else
        PS1="$PS1$PROMPT"
    fi
}
PROMPT_COMMAND=__prompt
