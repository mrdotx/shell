#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/old/host_status.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-01-15T13:57:24+0100

# color variables
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# ping host and echo online or offline
if ping -c 1 "$1" -w 1 >/dev/null 2>&1; then
    printf "%sonline %s" "${green}" "${reset}"
else
    printf "%soffline%s" "${red}" "${reset}"
fi
