cow() {
    which cowsay > /dev/null 2>&1 || return
    which fortune > /dev/null 2>&1 || return
    cow="$(ls /usr/share/cowsay/cows | shuf -n 1)"
    fortune -s | cowsay -n -f "$cow"
}
cow
