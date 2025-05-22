export LC_ALL=en_US.UTF-8
export LC_TIME=nl_NL.UTF-8
# I don't want the xcode-enforced credential helper
export GIT_CONFIG_NOSYSTEM=1

eval "$(rbenv init -)"
ulimit -Sn 20000
alias rot13='tr A-Za-z N-ZA-Mn-za-m'

# Docker idiocy
export DOCKER_SCAN_SUGGEST=false

# Brew2deb annoyance
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1

# Make it easy to inspect the docker vm
alias nsenter1='docker run -it --rm --privileged --pid=host justincormack/nsenter1'

# Iterm config
if [ -e /Applications/iTerm.app ] && [ ! -e ~/.config/iterm/com.googlecode.iterm2.plist ]; then
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.config/iterm"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
fi

printf() { if [ "$1" = "-v" ]; then command printf "$@"; else gprintf "$@"; fi; }

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
