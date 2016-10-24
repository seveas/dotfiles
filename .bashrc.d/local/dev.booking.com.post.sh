if [ ! -e /etc/bookings/DEVKVM ]; then return; fi
owner="$(</etc/bookings/DEVKVM)"
if [ "$owner" != "dkaarsemaker" ]; then return; fi
myrepo=/usr/local/git_tree/main
test -e $myrepo && cd $myrepo
