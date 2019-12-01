#!/bin/sh

# path:       ~/coding/shell/polybar_firewall.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 13:52:10

case "$1" in
    --polybar)
        if [ "$(systemctl is-active ufw.service)" = "active" ]
        then
        	echo "%{F#dfdfdf}%{o#00b200}%{o-}%{F-}"
        else
        	echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        fi
        ;;
    *)
        if [ "$(systemctl is-active ufw.service)" != "active" ]
        then
                sudo -A systemctl start ufw.service && \
                    notify-send -i "$HOME/coding/shell/icons/firewall.png" "Service" "Firewall started!" && \
                    exit 0
        else
                sudo -A systemctl stop ufw.service && \
                    notify-send -i "$HOME/coding/shell/icons/firewall.png" "Service" "Firewall stopped!" && \
                    exit 0
        fi
        ;;
esac
