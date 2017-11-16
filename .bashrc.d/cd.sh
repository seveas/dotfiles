not_with_sudo

__last_repo=
__cd() {
    __git_update
}
__git_update() {
    case "$(git config remote.origin.url),$(git config user.email)" in
    *github.com/github*,*github.com*)
        ;;
    *github.com/github*,*)
        export GIT_AUTHOR_EMAIL=seveas@github.com
        export GIT_COMMITTER_EMAIL=seveas@github.com
        ;;
    *github.com:github*,*)
        export GIT_AUTHOR_EMAIL=seveas@github.com
        export GIT_COMMITTER_EMAIL=seveas@github.com
        ;;
    *)
        unset GIT_AUTHOR_EMAIL
        unset GIT_COMMITTER_EMAIL
    esac
    __repo="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [ "$__repo" != "$__last_repo" ]; then
        __last_repo=$__repo
        ( set +m; git fetch -q --all 2>/dev/null & )
    fi
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
