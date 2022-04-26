# vim:syntax=bash
mkdir -p ~/.local/share/vim/undo
mkdir -p ~/.local/share/vim/swap

update_vim_git_plugins() {(
    cd ~/.vim/pack/git-plugins/start
    rm -f .shas-new
    for plugin in *; do
        git -C "$plugin" pull --ff-only
        echo "$plugin $(git -C $plugin remote get-url origin) $(git -C $plugin rev-parse HEAD)" >> .shas-new
    done
    mv .shas-new .shas
)}

checkout_vim_git_plugins() {
    cd ~/.vim/pack/git-plugins/start
    while read -r plugin repo sha; do
        if [ ! -e "$plugin" ]; then
            git clone "$repo" "$plugin"
        fi
        git -C "$plugin" reset -q --hard "$sha"
    done < .shas
}
