#!/bin/sh

# path:       ~/projects/shell/terminal_wrapper.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-20T14:39:42+0100

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

script=$(basename "$0")
help="$script [-h/--help] -- script for execute command in new terminal window
  Usage:
    $script [command]

  Examples:
    $script git status"

stat="The command exited with ${yellow}status $?${reset}.
"
keys="Press [${green}q${reset}]${green}uit${reset} \
to exit this window or [${green}s${reset}]${green}hell${reset} to run $SHELL..."

readc() {
    if [ -t 0 ]; then
        saved_tty_settings=$(stty -g)
        stty -icanon min 1 time 0
    fi
    eval "$1="
    while
        c=$(dd bs=1 count=1 2> /dev/null; echo .)
        c=${c%.}
        [ -n "$c" ] &&
            eval "$1=\${$1}"'$c
                [ "$(($(printf %s "${'"$1"'}" | wc -m)))" -eq 0 ]'; do
        continue
    done
    if [ -t 0 ]; then
        stty "$saved_tty_settings"
    fi
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -eq 0 ]; then
    echo "$help"
    exit 0
else
    "$@"
    echo
    key=""
    while true; do
        printf "\r%s" "${stat}${keys}" && readc "key"
        echo
        case "$key" in
            q|Q) exit 0 ;;
            s|S) $SHELL && exit 0;;
            *) stat=""
        esac
    done
fi
