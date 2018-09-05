gi() {
    if [ "${1:0:1}" = t ]; then
        a1=${1:1}
        shift
        git "$a1" "$@"
    else
        command gi "$@"
    fi
}
