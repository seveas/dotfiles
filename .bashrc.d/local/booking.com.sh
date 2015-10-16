if [ -e /etc/sysconfig/bookings.puppet ]; then
    . /etc/sysconfig/bookings.puppet
fi
http_proxy=${http_proxy:-http://webproxy.corp.booking.com:3128}
export http_proxy=$http_proxy
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy
export no_proxy="*.booking.com *.activehotels.net *.activehotels.com"

for role in $SERVERDB_ROLES; do
    if [ -e ~/.bashrc.d/local/role.sh ]; then
        . ~/.bashrc.d/local/role.sh
    fi
done
