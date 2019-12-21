#!/bin/sh

# path:       ~/projects/shell/polybar_bluetooth.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:55:38

case "$1" in
    --status)
        if [ "$(systemctl is-active bluetooth.service)" = "active" ]
        then
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        else
            echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
        fi
        ;;
    *)
        if [ "$(systemctl is-active bluetooth.service)" != "active" ]
        then
            sudo -A systemctl start bluetooth.service && \
            sudo -A systemctl start bluetooth.target && \
            sudo -A systemctl start ModemManager.service && \
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        else
            sudo -A systemctl stop bluetooth.service && \
            sudo -A systemctl stop bluetooth.target && \
            sudo -A systemctl stop ModemManager.service && \
            echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
        fi
        ;;
esac
