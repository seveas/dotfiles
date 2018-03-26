expand_ip() {
  (
    ip=
    nip=$1
    case $nip in
    ::1|127.*|fe80::*|169.254.*)
        return;;
    esac
    while [ "$ip" != "$nip" ]; do
        ip=$nip
        echo $ip
        nip=${ip%.*}
        nip=${nip%:*}
        nip=${nip%:}
    done
  ) | tac
}
expand_host() {
  (
    host=
    nhost=$1
    while [ "$host" != "$nhost" ]; do
        host=$nhost
        echo $host
        nhost=${host#*.}
    done
  ) | tac
}

for item in $(hostname -s) $(expand_host $(hostname -f)); do
    if [ -e ~/.bashrc.d/local/$item.$phase.sh ]; then
        . ~/.bashrc.d/local/$item.$phase.sh
    fi
done
type ip &>/dev/null || ip() { ifconfig; }
for ip in $(ip addr list  | sed -ne 's/.*inet6\? \([^ /]*\).*/\1/p'); do
    for item in $(expand_ip $ip); do
        if [ -e ~/.bashrc.d/local/$item.$phase.sh ]; then
            . ~/.bashrc.d/local/$item.$phase.sh
        fi
    done
done
type ip 2>&1 | grep -q function && unset ip

if [ -e ~/.bashrc.d/local/$(uname).$phase.sh ]; then
    . ~/.bashrc.d/local/$(uname).$phase.sh
fi
