#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/polybar_printer.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 15:04:31

case "$1" in
    --polybar)
        if [ "$(systemctl is-active org.cups.cupsd.service)" = "active" ]
        then
        	echo "%{F#dfdfdf}%{o#00b200}%{o-}%{F-}"
        else
        	echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        fi
        ;;
    *)
        if [ "$(systemctl is-active org.cups.cupsd.service)" != "active" ]
        then
                sudo -A systemctl start org.cups.cupsd.service && \
                    sudo -A systemctl start avahi-daemon.service && \
                    sudo -A systemctl start avahi-daemon.socket && \
                    notify-send -i "$HOME/coding/shell/icons/printer.png" "Service" "Printer and Avahi started!" && \
                    exit 0
        else
                sudo -A systemctl stop org.cups.cupsd.service && \
                    sudo -A systemctl stop avahi-daemon.service && \
                    sudo -A systemctl stop avahi-daemon.socket && \
                    notify-send -i "$HOME/coding/shell/icons/printer.png" "Service" "Printer and Avahi stopped!" && \
                    exit 0
        fi
        ;;
esac
