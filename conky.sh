#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/conky.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-29 11:01:53

service=conky
conky1=$HOME/.config/conky/klassiker_horizontal.conf
conky2=$HOME/.config/conky/klassiker_slim_horizontal.conf
conky3=$HOME/.config/conky/klassiker_vertical.conf
conky4=$HOME/.config/conky/shortcuts_foreground_left.conf
conky5=$HOME/.config/conky/shortcuts_foreground_middle.conf
conky6=$HOME/.config/conky/shortcuts_foreground_right.conf
conky7=$HOME/.config/conky/shortcuts_background_left.conf
conky8=$HOME/.config/conky/shortcuts_background_middle.conf
conky9=$HOME/.config/conky/shortcuts_background_right.conf

choice=$1

# if no config given use vertical
[ -z "$1" ] && {
choice=vertical
}

case "$choice" in
small)
    if [ "$(pgrep -f "$service -q -c $conky2")" ]; then
        # slim horizontal -> horizontal"
        kill -SIGTERM $(pgrep -f "$service -q -c $conky2") && $service -q -c "$conky1" &
        exit 0
    elif [ "$(pgrep -f "$service -c $conky1")" ]; then
        # horizontal -> slim horizontal"
        kill -SIGTERM $(pgrep -f "$service -q -c $conky1") && $service -q -c "$conky2" &
        exit 0
    else
        # start"
        $service -q -c "$conky1" &
        exit 0
    fi
    ;;
large)
    if [ "$(pgrep -f "$service -q -c $conky3")" ]; then
        # vertical -> stop"
        kill -SIGTERM $(pgrep -f "$service -q -c $conky3") && exit 0
    elif [ "$(pgrep -f "$service -q -c $conky2")" ]; then
        # slim horizontal -> vertical"
        kill -SIGTERM $(pgrep -f "$service -q -c $conky2") && $service -q -c "$conky3" &
        exit 0
    elif [ "$(pgrep -f "$service -q -c $conky1")" ]; then
        # horizontal -> slim horizontal"
        kill -SIGTERM $(pgrep -f "$service -q -c $conky1") && $service -q -c "$conky2" &
        exit 0
    else
        # start"
        $service -q -c "$conky1" &
        exit 0
    fi
    ;;
horizontal)
    if [ "$(pgrep -f "$service -q -c $conky1")" ]; then
        # stop"
        kill -SIGTERM $(pgrep -f "$service -q -c $conky1") &
        exit 0
    else
        # start"
        $service -q -c "$conky1" &
        exit 0
    fi
    ;;
slim-horizontal)
    if [ "$(pgrep -f "$service -q -c $conky2")" ]; then
        # stop"
        kill -SIGTERM $(pgrep -f "$service -q -c $conky2") &
        exit 0
    else
        # start"
        $service -q -c "$conky2" &
        exit 0
    fi
    ;;
vertical)
    if [ "$(pgrep -f "$service -q -c $conky3")" ]; then
        # stop"
        kill -SIGTERM $(pgrep -f "$service -q -c $conky3") &
        exit 0
    else
        # start"
        $service -q -c "$conky3" &
        exit 0
    fi
    ;;
shortcutsforeground)
    if [ "$(pgrep -f "$service -q -c $conky6")" ]; then
        # stop"
        kill -SIGTERM $(pgrep -f "$service -q -c $conky4") &
        kill -SIGTERM $(pgrep -f "$service -q -c $conky5") &
        kill -SIGTERM $(pgrep -f "$service -q -c $conky6") &
        exit 0
    else
        # start"
        $service -q -c "$conky4" &
        $service -q -c "$conky5" &
        $service -q -c "$conky6" &
        exit 0
    fi
    ;;
shortcutsbackground)
    if [ "$(pgrep -f "$service -q -c $conky9")" ]; then
        # stop"
        kill -SIGTERM $(pgrep -f "$service -q -c $conky7") &
        kill -SIGTERM $(pgrep -f "$service -q -c $conky8") &
        kill -SIGTERM $(pgrep -f "$service -q -c $conky9") &
        exit 0
    else
        # start"
        $service -q -c "$conky7" &
        $service -q -c "$conky8" &
        $service -q -c "$conky9" &
        exit 0
    fi
    ;;
esac