case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='history -a; echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    PROMPT_COMMAND='history -a'
    ;;
esac
