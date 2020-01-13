#!/bin/sh

# path:       ~/projects/shell/wlan.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:17:26+0100

script=$(basename "$0")
help="$script [--help/-h] -- script for networkmanager
  Usage:
    $script [-nm/-info/-detail]

  Settings:
    [-nm]     = opens networkmanager
    [-info]   = shows available wlans updated every 5 seconds
    [-detail] = shows available wlans

  Examples:
    $script -nm
    $script -info
    $script -detail"

case "$1" in
    -nm)
        # refresh wifi networks and open network manager
        nmcli device wifi list && nmtui
        ;;
    -info)
        watch -n5 nmcli dev wifi
        ;;
    -detail)
        nmcli -m multiline -f ALL dev wifi
        ;;
    *)
        echo "$help"
        exit 0
        ;;
esac
