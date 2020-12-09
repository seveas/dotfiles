export PATH=$PATH:~/kafka_2.13-2.6.0/bin
vpn() {
    osascript -e "tell application \"Viscosity\" to connect \"${1:-github-iad-prod}\""
}
alias gc2_console="ssh -L 39393:127.0.0.1:5900 -L 39394:127.0.0.1:5901 -L 39395:127.0.0.1:5902 -L 39396:127.0.0.1:5903 -L 39397:127.0.0.1:5904 -L 39398:127.0.0.1:5905 -L 39399:127.0.0.1:5906 -L 39400:127.0.0.1:5907 -L 39401:127.0.0.1:5907"
complete -F _ssh .deploy
