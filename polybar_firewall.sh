#!/bin/sh

# path:       ~/coding/shell/polybar_firewall.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-13 10:02:42

case "$1" in
    --status)
        if [ "$(systemctl is-active ufw.service)" = "active" ]
        then
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        else
            echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
        fi
        ;;
    *)
        if [ "$(systemctl is-active ufw.service)" != "active" ]
        then
            sudo -A systemctl start ufw.service && \
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        else
            sudo -A systemctl stop ufw.service && \
            echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
        fi
        ;;
esac
