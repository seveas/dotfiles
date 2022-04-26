not_with_sudo

__last_repo=
__cd() {
    __git_update
}
__git_update() {
    __repo="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [ "$__repo" != "$__last_repo" ]; then
        __last_repo=$__repo
        ( set +m; git fetch -q --all 2>/dev/null & )
    fi
}

cd() {
    command cd "$@" || return $?
    __cd || return 0
}
pushd() {
    command pushd "$@" || return $?
    __cd || return 0
}
popd() {
    command popd "$@" || return $?
    __cd || return 0
}
