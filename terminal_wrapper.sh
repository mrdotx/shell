#!/bin/bash

# path:       ~/coding/shell/terminal_wrapper.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 11:54:46

# color variables
#black=$(tput setaf 0)
red=$(tput setaf 1)
#green=$(tput setaf 2)
#yellow=$(tput setaf 3)
blue=$(tput setaf 4)
#magenta=$(tput setaf 5)
#cyan=$(tput setaf 6)
#white=$(tput setaf 7)
reset=$(tput sgr0)

# execute command in new terminal window
if [ $# -eq 0 ]; then "${SHELL:-bash}"; else "$@"; fi
echo; echo "    - The command exited with status ${blue}$?${reset}. -"

# wait for keypress
while true; do
    read -rsn1 -p "Press [${red}q${reset}]uit or [${red}c${reset}]lose to exit this window..." keypress; echo
    case "$keypress" in
        Q|q|C|c) exit 0
    esac
done
