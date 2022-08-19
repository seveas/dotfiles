export PATH=$PATH:~/code/kafka/bin
vpn() {
    (
        cd ~/Library/Application\ Support/Viscosity/OpenVPN/
        for f in */pkcs.p12; do
            if ! PASS= openssl pkcs12 -in $f -nokeys -clcerts -passin env:PASS 2>&1 | openssl x509 -checkend $((86400*7)) >/dev/null; then
                echo "Must update the vpn certs for $f - $(grep remote $f)"
                slack-send observability-chatops .vpn revoke &
                slack-tail observability-chatops --until 'Operation complete'
                make -C ~/github/vpn
                break
            fi
        done
    )

    osascript -e "tell application \"Viscosity\" to connect \"${1:-github-iad-prod}\""
    open -g "h"ttps://fido-challenger.githubapp.com/auth/vpn-prod
}
alias gc2_console="ssh -L 39393:127.0.0.1:5900 -L 39394:127.0.0.1:5901 -L 39395:127.0.0.1:5902 -L 39396:127.0.0.1:5903 -L 39397:127.0.0.1:5904 -L 39398:127.0.0.1:5905 -L 39399:127.0.0.1:5906 -L 39400:127.0.0.1:5907 -L 39401:127.0.0.1:5907"
complete -F _ssh .deploy
iterm-badge
