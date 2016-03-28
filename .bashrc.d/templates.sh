#!/bin/bash

test -n "$SUDO_USER" && return

for srcf in $(find ~/.template/ -type f); do
    dst="${srcf/.template\/}"
    if [ "$srcf" -nt "$dst" ]; then (
        content=
        mode=
        dirmode=
        dstdir="$(dirname $dst)"
        . "$srcf"
        if [ -n "$content" ]; then
            if [ ! -e "$dstdir" ]; then
                if [ -n "$dirmode" ]; then
                    mkdir -p -m "$dirmode" "$dstdir"
                else
                    mkdir -p "$dstdir"
                fi
            fi
            if [ ! -w "$dst" ]; then
                chmod u+w "$dst"
            fi
            echo "$content" > "$dst"
        fi
        if [ -n "$mode" ]; then
            chmod "$mode" "$dst"
        fi
    ) fi
done
