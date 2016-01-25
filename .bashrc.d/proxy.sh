no_proxy() {
    for envvar in $(env | sed -ne 's/_proxy=.*/_proxy/p'); do
        unset $envvar
    done
}
