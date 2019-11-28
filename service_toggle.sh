#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/service_toggle.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 21:58:38

service=$1

# if service ist not running turn it on and vice versa
if [[ $1 == "-h" || $1 == "--help" || $# -eq 0 ]]; then
    echo "Usage:"
    echo "  service_toggle.sh [servicename]"
    echo
    echo "Example:"
    echo "  service_toggle.sh bluetooth.service"
    echo
    echo "Example Services:"
    echo "  org.cups.cupsd.service | Print Service"
    echo "  bluetooth.service      | Bluetooth Service"
    echo "  ufw.service            | Firewall Service"
    echo
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
