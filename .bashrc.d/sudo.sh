sudohome="$HOME"
sudo() {
    declare -a args
    declare -a final_args
    while [ "$#" != 0 ]; do
        case "$1" in
            -i|--login)
                final_args+=('-H'  "$SHELL"  "--rcfile"  "$sudohome/.bashrc")
                shift
                ;;
            -C|--close-from|-p|--prompt|-r|--role|-t|--type|-U|--other-user|-u|--user)
                args+=("$1" "$2")
                shift; shift
                ;;
            --)
                break
                ;;
            -*)
                args+=("$1")
                shift
                ;;
            *)
                break
                ;;
        esac
    done
    command sudo "${args[@]}" "${final_args[@]}" "$@"
}
if [ -n "$SUDO_USER" ]; then
    alias vim="vim -u $sudohome/.vimrc"
fi
