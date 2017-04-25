latest_catalog () 
{ 
        sudo find /var/lib/puppet/client_data -type f | xargs sudo ls -t | head -n1
}

pjq () {
        sudo jq "$@" $(latest_catalog)
}
