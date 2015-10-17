__last_repo=
__cd() {
    # If changed to a different repo, fetch
    __repo="$(git rev-parse --show-toplevel 2>/dev/null)"
    case "$__repo,$__last_repo" in
    ,*|"$__repo,$__repo")
        ;;
    *)
        __last_repo=$__repo
        set +m
        git fetch -q --all &
        ;;
    esac
}
CD_COMMAND=__cd
