#!/bin/sh

# path:       ~/coding/shell/polybar_polkit.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-09 23:06:26

case "$1" in
    --polybar)
        if [ "$(pgrep -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1)" ]
        then
            echo "%{F#dfdfdf}%{o#00b200}%{o-}%{F-}"
        else
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        fi
        ;;
    *)
        if [ "$(pgrep -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1)" ]
        then
                killall /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 && \
                    notify-send -i "$HOME/coding/shell/icons/polkit.png" "Polkit" "Gnome Authentication Agent stopped!" && \
                    exit 0
        else
                /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 & \
                    notify-send -i "$HOME/coding/shell/icons/polkit.png" "Polkit" "Gnome Authentication Agent started!" && \
                    exit 0
        fi
        ;;
esac
