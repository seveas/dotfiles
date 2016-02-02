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
