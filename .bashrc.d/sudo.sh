sudohome="$HOME"
sudo() {
    declare -a args
    declare -a final_args
    while [ "$#" != 0 ]; do
        if [ "$1" = '-i' ]; then
            final_args+=('-H'  "$SHELL"  "--rcfile"  "$sudohome/.bashrc")
        else
            args+=($1)
        fi
        shift
    done
    command sudo "${args[@]}" "${final_args[@]}"
}
if [ -n "$SUDO_USER" ]; then
    alias vim="vim -u $sudohome/.vimrc"
fi
