#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/polybar_gestures.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 15:01:46

case "$1" in
    --polybar)
        if [ "$(pgrep -f /usr/bin/libinput-gestures)" ]
        then
        	echo "%{F#dfdfdf}%{o#00b200}%{o-}%{F-}"
        else
        	echo "%{F#dfdfdf}%{o#ff5555}%{o-}%{F-}"
        fi
        ;;
    *)
        if [ "$(pgrep -f /usr/bin/libinput-gestures)" ]
        then
                libinput-gestures-setup stop && \
                    notify-send -i "$HOME/coding/shell/icons/gestures.png" "LibInput" "LibInput Gestures stopped!" && \
                    exit 0
        else
                libinput-gestures-setup start >/dev/null 2>&1 && \
                    notify-send -i "$HOME/coding/shell/icons/gestures.png" "LibInput" "LibInput Gestures started!" && \
                    exit 0
        fi
        ;;
esac
