#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/wlan.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:44:56+0200

script=$(basename "$0")
help="$script [--help/-h] -- script for iwctl
  Usage:
    $script [-nm/-info]

  Settings:
    [-nm]    = opens iwctl
    [-info]  = shows available wlans

  Examples:
    $script -iw
    $script -info
    $script -watch"

case "$1" in
    -iw)
        iwctl
        ;;
    -info)
        iwctl station wlan0 scan
        iwctl station wlan0 get-networks
        ;;
    *)
        printf "%s\n" "$help"
        exit 0
        ;;
esac
