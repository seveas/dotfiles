latest_catalog () 
{ 
        /bin/sudo sh -c 'path=/var/lib/puppet/client_data/catalog/$(hostname -f)/production; while test -d "$path"; do path="$path/$(ls $path|sort -n|tail -n1)"; done; echo $path'
}

pjq () {
        sudo jq "$@" $(latest_catalog)
}
