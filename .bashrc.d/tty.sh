# Disable flow control, I only ever use it accidently
stty -ixon -ixoff

share-tty() {
    chmod 777 $(readlink -f /dev/stdin)
}
