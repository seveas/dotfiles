export PATH=~/Library/Python/2.7/bin:$PATH
export PYTHONPATH=~/Library/Python/2.7/lib:$PYTHONPATH
export LC_ALL=en_US.UTF-8
export LC_TIME=nl_NL.UTF-8
# I don't want the xcode-enforced credential helper
export GIT_CONFIG_NOSYSTEM=1

. /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
eval "$(rbenv init -)"
