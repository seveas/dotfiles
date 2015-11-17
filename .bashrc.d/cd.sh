test -n "$SUDO_USER" && return
__last_repo=
__cd() {
    __maybe_fetch
    __fix_git_config
}
__maybe_fetch() {
    # If changed to a different repo, fetch
    __repo="$(git rev-parse --show-toplevel 2>/dev/null)"
    case "$__repo,$__last_repo" in
    ,*|"$__repo,$__repo")
        ;;
    *)
        __last_repo=$__repo
        git fetch -q --all 2>/dev/null &
        ;;
    esac
}
__fix_git_config() {
    case "$(git config remote.origin.url),$(git config user.email)" in
    *booking.com*,*booking.com*)
        ;;
    *booking.com*,*)
        echo "Fixing user configuration"
        git config user.email dennis.kaarsemaker@booking.com
        ;;
    esac
}

cd() {
    command cd "$@"
    ( set +m; __cd )
}
