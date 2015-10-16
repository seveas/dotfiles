cow() {
    which cowsay > /dev/null || return
    which fortune > /dev/null || return 
    cow="$(ls /usr/share/cowsay/cows | shuf -n 1)"
    fortune -s | cowsay -n -f "$cow"
}
cow
