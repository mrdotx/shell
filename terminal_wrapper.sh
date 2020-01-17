#!/usr/bin/env bash

# path:       ~/projects/shell/terminal_wrapper.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-17T15:52:59+0100

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
    "${SHELL:-bash}";
else
    "$@";
fi
echo

stat="The command exited with ${yellow}status $?${reset}.
"
keys="Press ${green}ESC${reset}, [${green}q${reset}]${green}uit${reset} \
to exit this window or [${green}s${reset}]${green}hell${reset} to run $SHELL..."

# wait for key
while true; do
    read -rsN1 -p "${stat}${keys}" key
    echo
    case "$key" in
        q|Q|$'\x1B') exit 0 ;;
        s|S) $SHELL && exit 0;;
        *) stat=""
    esac
done
