for role in $SERVERDB_ROLE_NAMES; do
    if [ -e ~/.bashrc.d/local/$role.$phase.sh ]; then
        . ~/.bashrc.d/local/$role.$phase.sh
    fi
done
