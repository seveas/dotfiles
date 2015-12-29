# Get rid of vestiges of old submodules
for file in ~/.config/vcsh/repo.d/dotfiles.git/modules ~/.vim/bundle/bind.vim/.git ~/.vim/bundle/vim-fugitive/.git; do
    test -e "$file" && rm -rf "$file"
done
