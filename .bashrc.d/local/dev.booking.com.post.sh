owner="$(</etc/bookings/DEVKVM_USER)"
if [ "$owner" != "dkaarsemaker" ]; then return; fi
myrepo=/usr/local/git_tree/main
test -e $myrepo && cd $myrepo
