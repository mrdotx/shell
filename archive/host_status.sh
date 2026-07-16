#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/archive/host_status.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:50:55+0200

# use standard C locale to avoid locale-specific issues and improve performance
export LC_ALL=C LANG=C

# color variables for the interactive shell
tty -s \
    && reset="\033[0m" \
    && red="\033[31m" \
    && green="\033[32m"

# ping host and echo online or offline
ping -c1 -W1 -q "$1" >/dev/null 2>&1 \
    && printf "%bonline%b\n" "$green" "$reset" \
    && exit 0

printf "%boffline%b\n" "$red" "$reset"
