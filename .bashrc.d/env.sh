export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-MQCFSX'
export LESSUTFBINFMT='*n%lc'
export LESS_TERMCAP_so=$'\e'"[37;2;7m"
export LESS_TERMCAP_se=$'\e'"[0m"
export PATH=~/bin:~/.local/bin:~/go/bin/:$PATH:~/code/hacks
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S: "
export PERL5LIB=~/perl/lib/perl5:$PERL5LIB
export EMAIL=dennis@kaarsemaker.net
export GOPATH=~/go
export DEBEMAIL=$EMAIL
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
eval $(dircolors ~/.config/dircolors)
export LS_COLORS
export DIRENV_LOG_FORMAT=
