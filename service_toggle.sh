#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/service_toggle.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:43:02+0200

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

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -eq 0 ]; then
    printf "%s\n" "$help"
elif [ "$(systemctl is-active "$service")" != "active" ]; then
    printf "%s wasn't running so attempting to start\n" "$service"
    systemctl start "$service"
else
    printf "%s was running so attempting to stop\n" "$service"
    systemctl stop "$service"
fi
