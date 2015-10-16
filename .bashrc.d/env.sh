export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-MQiCFsSX'
export PATH=~/bin:$PATH:~/code/hacks
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export PERL5LIB=~/perl/lib/perl5:$PERL5LIB
export GOROOT=~/go
export EMAIL=dennis@kaarsemaker.net
export DEBEMAIL=$EMAIL
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
fi
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
