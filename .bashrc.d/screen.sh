screen-takeover() {
    share-tty
    user="$1"
    shift
    sudo -u "$user" screen -r "$@"
}

tmux-takeover() {
    user="$1"
    shift
    sudo -u "$user" tmux attach "$@"
}

if [ -n "$TMUX" ]; then
    export TERM=screen-256color
fi
