#!/bin/sh

# path:       ~/projects/shell/wlan.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-09 12:16:28

script=$(basename "$0")
help="$script [--help/-h] -- script for networkmanager
  Usage:
    $script [-nm/-info]

  Settings:
    [-nm]   = opens networkmanager
    [-info] = shows available wlans

  Examples:
    $script -nm
    $script -info"

case "$1" in
    -info)
        watch -n5 nmcli device wifi list
        ;;
    -nm)
        # refresh wifi networks and open network manager
        nmcli device wifi list && nmtui
        ;;
    *)
        echo "$help"
        exit 0
        ;;
esac
