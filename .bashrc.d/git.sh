gi() {
    if [ "${1:0:1}" = t ]; then
        a1=${1:1}
        shift
        git "$a1" "$@"
    else
        command gi "$@"
    fi
}

clone() {
    case $1 in
        */*)
            owner=${1%%/*}
            repo=${1##*/}
            if [ $owner == "github" ]; then
                cd ~/github
            else
                cd ~/code
            fi
            ;;
        *)
            owner=$(gh api /user | jq -r .login)
            repo=$1
            cd ~/code
            ;;
    esac
    gh repo clone "$owner/$repo"
    cd "$repo"
}

r() {
    case $1 in
        */*)
            if [ -e "$HOME/$1" ]; then
                cd "$HOME/$1"
            else
                clone "$1"
            fi
            ;;
        *)
            if [ -e "$HOME/github/$1" ]; then
                cd "$HOME/github/$1"
            elif [ -e "$HOME/code/$1" ]; then
                cd "$HOME/code/$1"
            else
                clone "github/$1"
            fi
    esac
}
_r() {
    COMPREPLY=("${COMPREPLY[@]}" $(compgen -W "$(find $HOME/github $HOME/code -maxdepth 1 -type d -printf '%P ')" -- ${COMP_WORDS[COMP_CWORD]}))
}
complete -F _r r
