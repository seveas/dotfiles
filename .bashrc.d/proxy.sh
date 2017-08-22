no_proxy() {
    for envvar in $(env | sed -ne 's/^\(.*_proxy\)=.*/\1/pi'); do
        unset $envvar
    done
}
