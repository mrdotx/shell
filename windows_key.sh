#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/windows_key.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-06-11T16:00:24+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

check_root() {
    [ "$(id -u)" -ne 0 ] \
        && printf "this script needs root privileges to run\n" \
        && exit 1
}

check_root
strings "/sys/firmware/acpi/tables/MSDM" \
    | tail -n1
