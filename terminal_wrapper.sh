#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/terminal_wrapper.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:44:07+0200

# color variables
# black=$(tput setaf 0)
# red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
# blue=$(tput setaf 4)
# magenta=$(tput setaf 5)
# cyan=$(tput setaf 6)
# white=$(tput setaf 7)
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

read_c() {
    [ -t 0 ] \
        && sav_tty_set=$(stty -g) \
        && stty -icanon min 1 time 0
    eval "$1="
    while
        c=$(dd bs=1 count=1 2> /dev/null; printf .)
        c=${c%.}
        [ -n "$c" ] &&
            eval "$1=\${$1}"'$c
                [ "$(($(printf %s "${'"$1"'}" | wc -m)))" -eq 0 ]'; do
        continue
    done
    printf "\r"
    [ -t 0 ] \
        && stty "$sav_tty_set"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -eq 0 ]; then
    printf "%s\n" "$help"
    exit 0
else
    "$@"
    key=""
    while true; do
        printf "\n\r%s%s" "${stat}" "${keys}" && read_c "key"
        case "$key" in
            q|Q)
                exit 0
                ;;
            s|S)
                $SHELL \
                && exit 0
                ;;
            *)
                stat=""
                ;;
        esac
    done
fi
