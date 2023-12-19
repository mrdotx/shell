#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/old/host_status.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-12-18T17:34:59+0100

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# color variables
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# ping host and echo online or offline
ping -c1 -W1 -q "$1" >/dev/null 2>&1 \
    && printf "%sonline%s\n" "$green" "$reset" \
    && exit 0

printf "%soffline%s\n" "$red" "$reset"
