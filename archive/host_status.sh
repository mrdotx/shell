#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/archive/host_status.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-04-25T10:01:44+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# color variables
red="\033[31m"
green="\033[32m"
reset="\033[0m"

# ping host and echo online or offline
ping -c1 -W1 -q "$1" >/dev/null 2>&1 \
    && printf "%bonline%b\n" "$green" "$reset" \
    && exit 0

printf "%boffline%b\n" "$red" "$reset"
