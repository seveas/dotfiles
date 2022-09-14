if [ -n "$CODESPACE_NAME" ]; then
    CODESPACE_ALIAS=$(echo $CODESPACE_NAME | awk -F - '{print "codespace:" $2 "/" $3}')
    for repo in /workspaces/*; do
        if [[ $(git -C $repo config remote.origin.url) =~ github/ ]]; then
            git -C $repo config user.email seveas@github.com
        fi
    done
fi
