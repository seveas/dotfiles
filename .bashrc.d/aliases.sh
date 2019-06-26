alias ls='ls --color=auto'
alias grep="grep --color"
alias bc='bc -lq'
alias ftp='ftp -vp'
alias j='jobs -l'
alias h='history 23'
alias bitch,=sudo
alias anon='export HISTFILE=/dev/null'
alias whitespacenazi="ack ' +$'"
alias random-folder='ls -d */ | sort --random-sort | head -n1 | tee /dev/stderr'
alias hunter2='apg -a1 -m24 -x36 -n1'
alias aton='python -c "import sys,socket,struct; print(struct.unpack(\"!I\", socket.inet_aton(sys.argv[1]))[0])"'
alias ntoa='python -c "import sys,socket,struct; print(socket.inet_ntoa(struct.pack(\"!I\", int(sys.argv[1]))))"'
alias today='echo $(($(date +%s)/86400))'
alias lscg=systemd-cgls
alias dig='dig +noall +answer'
alias ldapsearch='ldapsearch -o ldif-wrap=no -x -LLL'
alias ldapdecode='awk '\''BEGIN{FS=":: ";c="base64 -d"}{if(/\w+:: /) {print $2 |& c; close(c,"to"); c |& getline $2; close(c); printf("%s:: \"%s\"\n", $1, $2); next} print $0 }'\'''
alias ßh=ssh
alias strace-f='strace -f -qq -esignal=!SIGCHLD'
