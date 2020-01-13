#!/bin/sh

# path:       ~/projects/shell/polybar_firewall.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:15:23+0100

grey=$(xrdb -query | grep Polybar.foreground1: | cut -f2)
red=$(xrdb -query | grep color9: | cut -f2)

case "$1" in
    --status)
        if [ "$(systemctl is-active ufw.service)" = "active" ]
        then
            echo "%{o$red}%{o-}"
        else
            echo "%{o$grey}%{o-}"
        fi
        ;;
    *)
        if [ "$(systemctl is-active ufw.service)" != "active" ]
        then
            sudo -A systemctl start ufw.service \
                && echo "%{o$red}%{o-}"
        else
            sudo -A systemctl stop ufw.service \
                && echo "%{o$grey}%{o-}"
        fi
        ;;
esac
