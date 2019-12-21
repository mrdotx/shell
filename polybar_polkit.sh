#!/bin/sh

# path:       ~/projects/shell/polybar_polkit.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:56:29

case "$1" in
    --status)
        if [ "$(pgrep -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1)" ]
        then
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        else
            echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
        fi
        ;;
    *)
        if [ "$(pgrep -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1)" ]
        then
            killall /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 && \
            echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
        else
            /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 & \
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        fi
        ;;
esac
