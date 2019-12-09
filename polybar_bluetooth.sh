#!/bin/sh

# path:       ~/coding/shell/polybar_bluetooth.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-09 23:07:31

case "$1" in
    --polybar)
        if [ "$(systemctl is-active bluetooth.service)" = "active" ]
        then
            echo "%{F#dfdfdf}%{o#00b200}%{o-}%{F-}"
        else
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        fi
        ;;
    *)
        if [ "$(systemctl is-active bluetooth.service)" != "active" ]
        then
                sudo -A systemctl start bluetooth.service && \
                    sudo -A systemctl start bluetooth.target && \
                    sudo -A systemctl start ModemManager.service && \
                    notify-send -i "$HOME/coding/shell/icons/bluetooth.png" "Service" "Bluetooth and ModemManager started!" && \
                    exit 0
        else
                sudo -A systemctl stop bluetooth.service && \
                    sudo -A systemctl stop bluetooth.target && \
                    sudo -A systemctl stop ModemManager.service && \
                    notify-send -i "$HOME/coding/shell/icons/bluetooth.png" "Service" "Bluetooth and ModemManager stopped!" && \
                    exit 0
        fi
        ;;
esac
