#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/old/passgen.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-12-21T10:05:11+0100

c=14
i=1

while [ 1 -le "$#" ]; do
    case "$1" in
        -c)
            c=$2
            shift 2
            ;;
        -i)
            i=$2
            shift 2
            ;;
        *)
            script=$(basename "$0")
		    printf "usage: %s [-c 14] [-i 5]\n" "$script"
            exit 1
            ;;
    esac
done

while [ 1 -le "$i" ]; do
    printf "%s\n" "$(tr -dc A-Za-z0-9 < /dev/urandom | head -c"$c")"
    i=$((i - 1))
done
