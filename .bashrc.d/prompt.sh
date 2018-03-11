if declare -f __git_ps1 > /dev/null; then
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUPSTREAM=auto
    GIT_PS1_DESCRIBE_STYLE=branch
    GIT_PS1_SHOWCOLORHINTS=1
    PS1_GIT=1
fi
declare -A EXIT_CODES

EXIT_CODES[64]=EX_USAGE
EXIT_CODES[65]=EX_DATAERR
EXIT_CODES[66]=EX_NOINPUT
EXIT_CODES[67]=EX_NOUSER
EXIT_CODES[68]=EX_NOHOST
EXIT_CODES[69]=EX_UNAVAILABLE
EXIT_CODES[70]=EX_SOFTWARE
EXIT_CODES[71]=EX_OSERR
EXIT_CODES[72]=EX_OSFILE
EXIT_CODES[73]=EX_CANTCREAT
EXIT_CODES[74]=EX_IOERR
EXIT_CODES[75]=EX_TEMPFAIL
EXIT_CODES[76]=EX_PROTOCOL
EXIT_CODES[77]=EX_NOPERM
EXIT_CODES[78]=EX_CONFIG
# From the timeout command
EXIT_CODES[124]=TIMEOUT
# Posix shells
EXIT_CODES[126]=command-not-executable
EXIT_CODES[127]=command-not-found
# Yes, these signals are linux-on-x86-specific
EXIT_CODES[129]=SIGHUP
EXIT_CODES[130]=SIGINT
EXIT_CODES[131]=SIGQUIT
EXIT_CODES[132]=SIGILL
EXIT_CODES[133]=SIGTRAP
EXIT_CODES[134]=SIGABRT
EXIT_CODES[135]=SIGBUS
EXIT_CODES[136]=SIGFPE
EXIT_CODES[137]=SIGKILL
EXIT_CODES[138]=SIGUSR1
EXIT_CODES[139]=SIGSEGV
EXIT_CODES[140]=SIGUSR2
EXIT_CODES[141]=SIGPIPE
EXIT_CODES[142]=SIGALRM
EXIT_CODES[143]=SIGTERM
EXIT_CODES[144]=SIGSTKFLT
EXIT_CODES[145]=SIGCHLD
EXIT_CODES[147]=SIGSTOP
EXIT_CODES[148]=SIGTSTP
EXIT_CODES[152]=SIGXCPU
EXIT_CODES[153]=SIGXFSZ
EXIT_CODES[154]=SIGVTALRM
EXIT_CODES[155]=SIGPROF
EXIT_CODES[157]=SIGIO
EXIT_CODES[158]=SIGPWR

type direnv &>/dev/null || direnv() { : ; }

signal() {
    if [ -n "${EXIT_CODES[$1]}" ]; then
        echo ${EXIT_CODES[$1]}
    elif [ -n "${EXIT_CODES[$(($1+128))]}" ]; then
        echo ${EXIT_CODES[$(($1+128))]}
    else (
        shopt -s nocasematch
        for key in ${!EXIT_CODES[@]}; do
            if [[ $1 =~ ^SIG ]] && [[ ${EXIT_CODES[$key]} =~ ^$1$ ]]; then
                echo $((key-128))
                return
            elif [[ ${EXIT_CODES[$key]} =~ ^(EX_)?$1$ ]]; then
                echo $key
                return
            elif [[ ${EXIT_CODES[$key]} =~ ^(SIG)?$1$ ]]; then
                echo $((key-128))
                return
            fi
        done
    ) fi
}

case "$SUDO_USER,$USER" in
*,root)
    USERX="\[\033[31;1m\]$USER\[\033[0m@\]"
    PROMPT='# '
    ;;
,*)
    USERX=
    PROMPT='$ '
    ;;
*)
    USERX="$USER@"
    PROMPT='$ '
    ;;
esac

__prompt() {
    rc=$?
    case $rc in
    0)
        FAIL=
        ;;
    1)
        FAIL="\[\033[31;1m\]! \[\033[0m\]"
        ;;
    *)
        if [ -n "${EXIT_CODES[$rc]}" ]; then
            rc="$rc,${EXIT_CODES[$rc]}"
        fi
        FAIL="\[\033[31;1m\]!($rc) \[\033[0m\]"
    esac
    DEPLOY=
    if [ -e .deploy ]; then
        color=32
        if [ -e .git/git-deploy ]; then
            color=33
            if [ $(stat --format %U .git/git-deploy/start) != $USER ]; then
                color=31
            fi
        fi
        DEPLOY=" \[\033[$color;1m\][DEPLOY]\[\033[0m\]"
    fi
    history -a
    H='~'
    case "$TERM" in
    xterm*|rxvt*)
        echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/$HOME/$H}\007"
        ;;
    esac
    PS1="$FAIL$VCSH$USERX${HOSTNAME%%.*}:${PWD/$HOME/$H}$DEPLOY"
    if [ "$PS1_GIT" == 1 ]; then
        __git_ps1 "$PS1" "$PROMPT"
    else
        PS1="$PS1$PROMPT"
    fi
    eval "$(direnv export bash)"
}
PROMPT_COMMAND=__prompt
