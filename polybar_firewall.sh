#!/bin/sh

# path:       ~/projects/shell/polybar_firewall.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:56:05

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
