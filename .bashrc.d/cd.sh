test -n "$SUDO_USER" && return
__last_repo=
__cd() {
    __git_update
}
__git_update() {
     __repo="$(git rev-parse --show-toplevel 2>/dev/null)"
    case "$(git config remote.origin.url),$(git config user.email)" in
    *booking.com*,*booking.com*)
        ;;
    *booking.com*,*)
        export GIT_AUTHOR_EMAIL=dennis.kaarsemaker@booking.com
        export GIT_COMMITTER_EMAIL=dennis.kaarsemaker@booking.com
        ;;
    *)
        unset GIT_AUTHOR_EMAIL
        unset GIT_COMMITTER_EMAIL
        if [ "$__repo" != "$__last_repo" ]; then
            __last_repo=$__repo
            ( set +m; git fetch -q --all 2>/dev/null & )
        fi
    esac
}

cd() {
    command cd "$@" || return $?
    __cd
}
pushd() {
    command pushd "$@" || return $?
    __cd
}
popd() {
    command popd "$@" || return $?
    __cd
}
