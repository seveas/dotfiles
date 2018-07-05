gi() {
    if [ "${1:0:1}" = t ]; then
        a1=${1:1}
        shift
        git "$a1" "$@"
    else
        command gi "$@"
    fi
}

which git-hub &>/dev/null && export GITHUB_API_TOKEN=$(git hub config token)
