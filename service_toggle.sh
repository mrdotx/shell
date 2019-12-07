#!/bin/sh

# path:       ~/coding/shell/service_toggle.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-07 22:35:58

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
    echo "$help"
    exit 0
elif [ "$(systemctl is-active "$service")" != "active" ]; then
    echo "$service wasn't running so attempting to start"
    sudo systemctl start "$service"
    notify-send -i "$HOME/coding/shell/icons/service.png" "$service" "started!"
    exit 0
else
    echo "$service was running so attempting to stop"
    sudo systemctl stop "$service"
    notify-send -i "$HOME/coding/shell/icons/service.png" "$service" "stopped!"
    exit 0
fi
