# Disable flow control, I only ever use it accidently
stty -ixon -ixoff

test -n "$SUDO_USER" && return
if [ -f /usr/bin/gsettings ] && [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
    gsettings set org.compiz.integrated command-1 /usr/bin/terminator
    gsettings set org.compiz.integrated run-command-1 "['<Super>t']"
    gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Alt>m']"
fi
