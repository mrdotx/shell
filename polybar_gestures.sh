#!/bin/sh

# path:       ~/coding/shell/polybar_gestures.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-13 10:11:07

case "$1" in
    --status)
        if [ "$(pgrep -f /usr/bin/libinput-gestures)" ]
        then
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        else
            echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
        fi
        ;;
    *)
        if [ "$(pgrep -f /usr/bin/libinput-gestures)" ]
        then
            libinput-gestures-setup stop && \
            echo "%{F#dfdfdf}%{o#666666}%{o-}%{F-}"
        else
            libinput-gestures-setup start >/dev/null 2>&1 && \
            echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        fi
        ;;
esac
