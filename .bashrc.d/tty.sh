share-tty() {
    chmod 777 $(readlink -f /dev/stdin)
}
