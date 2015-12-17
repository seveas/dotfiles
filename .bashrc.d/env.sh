export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-MQCFSX'
export LESSUTFBINFMT='*n%lc'
export PATH=~/bin:~/go/bin/:$PATH:~/code/hacks
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export PERL5LIB=~/perl/lib/perl5:$PERL5LIB
export EMAIL=dennis@kaarsemaker.net
export GOPATH=~/go
export DEBEMAIL=$EMAIL
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
fi
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
