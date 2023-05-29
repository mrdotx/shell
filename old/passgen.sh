#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/old/passgen.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-05-28T21:47:11+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
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
