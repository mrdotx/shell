#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/servicetoggle.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# variables {{{
SERVICE=$1
# }}}

# procedure {{{
if [[ $1 == "-h" || $1 == "--help" || $# -eq 0 ]]; then
    echo "Usage:"
    echo "	servicetoggle.sh [servicename]"
    echo
    echo "Example:"
    echo "	servicetoggle.sh bluetooth.service"
    echo
    echo "Example Services:"
    echo "	org.cups.cupsd.service | Print Service"
    echo "	bluetooth.service      | Bluetooth Service"
    echo "	ufw.service            | Firewall Service"
    echo
    exit 0
elif [ "$(systemctl is-active $SERVICE)" != "active" ]; then
    echo "$SERVICE wasnt running so attempting to start"
    sudo systemctl start $SERVICE
    notify-send $SERVICE "started!"
    exit 0
else
    echo "$SERVICE was running so attempting to stop"
    sudo systemctl stop $SERVICE
    notify-send $SERVICE "stopped!"
    exit 0
fi
# }}}