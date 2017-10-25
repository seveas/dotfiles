not_with_sudo
test -z "$DBUS_SESSION_BUS_ADDRESS" && return
test -x /usr/bin/gsettings || return
test ~/.config/gsettings.dump -nt ~/.config/gsettings.dump.ts && {
    while read schema key val; do
        gsettings set "$schema" "$key" "$val"
    done < ~/.config/gsettings.dump

    touch ~/.config/gsettings.dump.ts
}
