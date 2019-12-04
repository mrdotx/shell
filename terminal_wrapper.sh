#!/usr/bin/env bash

# path:       ~/coding/shell/terminal_wrapper.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-04 16:06:57

# color variables
#black=$(tput setaf 0)
#red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
#blue=$(tput setaf 4)
#magenta=$(tput setaf 5)
#cyan=$(tput setaf 6)
#white=$(tput setaf 7)
reset=$(tput sgr0)

# execute command in new terminal window
if [ $# -eq 0 ]; then
    "${SHELL:-zsh}";
else
    "$@";
fi
echo

cmdstatus="The command exited with ${yellow}status $?${reset}. "

# wait for keypress
while true; do
    read -rsn1 -p "${cmdstatus}Press [${green}q${reset}]${green}uit${reset} to exit this window or [${green}s${reset}]${green}hell${reset} to run $SHELL..." keypress
    echo
    case "$keypress" in
        q|Q) exit 0 ;;
        s|S) $SHELL && exit 0;;
        *) cmdstatus=""
    esac
done
