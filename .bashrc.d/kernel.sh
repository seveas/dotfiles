kernel-cleanup() {
    test -x /usr/bin/dpkg || { echo "Not a debian-ish system"; return 1; }
    latest=$(apt-cache depends linux-image-generic | sed -ne 's/.*Depends: linux-image-\([1-9][^ ]*\)/\1/p')
    running=$(uname -r)
    toremove=$(
        dpkg -l 'linux-image-[0-9]*' 'linux-headers-[0-9]*' 'linux-signed-image-[0-9]*' 'linux-image-unsigned-[0-9]*' |
        awk '/^ii/{print $2}' |
        grep -v "\(${running%%-generic}\|${latest%%-generic}\)"
    )
    test -n "$toremove" && sudo apt-get remove --purge $toremove
}
