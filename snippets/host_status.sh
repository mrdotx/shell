#!/bin/sh

# path:       ~/projects/shell/snippets/host_status.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-02-24T12:39:42+0100

# color variables
#black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
#yellow=$(tput setaf 3)
#blue=$(tput setaf 4)
#magenta=$(tput setaf 5)
#cyan=$(tput setaf 6)
#white=$(tput setaf 7)
reset=$(tput sgr0)

# ping host and echo online or offline
if ping -c 1 "$1" -w 1 >/dev/null 2>&1; then
    printf "%sonline %s" "${green}" "${reset}"
else
    printf "%soffline%s" "${green}" "${reset}"
fi
