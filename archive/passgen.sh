#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/archive/passgen.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-08-11T04:53:47+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# helper functions
check_password() {
    # check if at least 1 of each char type is available
    for char in [$2] [0-9] [A-Z] [a-z]; do
        printf "%s" "$1" \
            | grep -q "$char" \
                || return 1
    done
}

generate_password() {
    while true; do
        password=$(printf "%s" \
            "$(tr -dc "[:alnum:]$2" < /dev/urandom \
                | head -c"$1")" \
        )

        check_password "$password" "$2" \
            && printf "%s\n" "$password" \
            && break
    done
}

# options
while [ 1 -le "$#" ]; do
    case "$1" in
        -c | --chars)
            chars=$2
            shift 2
            ;;
        -i | --iterations)
            iterations=$2
            shift 2
            ;;
        *)
            printf "usage: %s [-c/--chars 24] [-i/--iterations 5]\n" \
                "$(basename "$0")"
            exit 1
            ;;
    esac
done

# main
while [ "${iterations:-1}" -ge 1 ]; do
    generate_password "${chars:-16}" "!@#"
    iterations=$((iterations - 1))
done
