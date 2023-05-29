#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/old/host_status.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-05-28T21:45:50+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# color variables
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# ping host and echo online or offline
ping -c1 -W1 -q "$1" >/dev/null 2>&1
case $? in
    0)
        printf "%sonline%s\n" "$green" "$reset"
        ;;
    *)
        printf "%soffline%s\n" "$red" "$reset"
        ;;
esac
