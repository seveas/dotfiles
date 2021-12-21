export LC_ALL=en_US.UTF-8
export LC_TIME=nl_NL.UTF-8
# I don't want the xcode-enforced credential helper
export GIT_CONFIG_NOSYSTEM=1

eval "$(rbenv init -)"
export GITHUB_API_TOKEN=$(git hub config token)
export GITHUB_TOKEN=$GITHUB_API_TOKEN
ulimit -Sn 20000
alias rot13='tr A-Za-z N-ZA-Mn-za-m'

# I want a functional, non-littering, sed -i
export PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH

# Docker idiocy
export DOCKER_SCAN_SUGGEST=false

# Iterm config
mkdir -p ~/.config/iterm
if defaults domains | grep -q com.googlecode.iterm2; then
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.config/iterm"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
fi
