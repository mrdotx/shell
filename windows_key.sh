#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/windows_key.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-06-11T20:29:51+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
key_file="/sys/firmware/acpi/tables/MSDM"

check_root() {
    [ "$(id -u)" -ne 0 ] \
        && printf "this script needs root privileges to run\n" \
        && exit 1
}

check_root
[ -s "$key_file" ] \
    && strings "$key_file" \
        | tail -n1 \
    && exit 0

printf "sorry, windows product key not found\n"
