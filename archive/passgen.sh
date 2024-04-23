#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/archive/passgen.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-04-22T19:20:17+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
chars=16
symbols='!@#'
iterations=1

while [ 1 -le "$#" ]; do
    case "$1" in
        -c)
            chars=$2
            shift 2
            ;;
        -i)
            iterations=$2
            shift 2
            ;;
        *)
            script=$(basename "$0")
            printf "usage: %s [-c 24] [-i 5]\n" "$script"
            exit 1
            ;;
    esac
done

while [ 1 -le "$iterations" ]; do
    while [ -z "$check" ]; do
        check=1
        password=$(printf "%s" \
            "$(tr -dc "[:alnum:]$symbols" < /dev/urandom \
                | head -c"$chars")" \
        )

        # check if at least 1 of each char type is available
        for char in [$symbols] [0-9] [A-Z] [a-z]; do
            printf "%s" "$password" \
                | grep -q "$char" \
                    || unset check

            [ -z "$check" ] \
                && break
        done
    done

    printf "%s\n" "$password"
    unset check
    iterations=$((iterations - 1))
done
