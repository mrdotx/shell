#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/archive/service_toggle.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:51:31+0200

# use standard C locale to avoid locale-specific issues and improve performance
export LC_ALL=C LANG=C

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to toggle services on and off
  Usage:
    $script [servicename]

  Setting:
    [servicename]            = name of the service to be toggle
      org.cups.cupsd.service | Print Service
      bluetooth.service      | Bluetooth Service
      ufw.service            | Firewall Service
      ...

  Example:
    $script bluetooth.service"

service=$1

if [ "$1" = "-h" ] || [ "$1" = "--help" ] \
    || [ $# -eq 0 ]; then
        printf "%s\n" "$help"
elif systemctl -q is-active "$service"; then
    printf "%s was running so attempting to stop\n" "$service"
    systemctl stop "$service"
else
    printf "%s wasn't running so attempting to start\n" "$service"
    systemctl start "$service"
fi
