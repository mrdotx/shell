#!/bin/sh

# path:       ~/projects/shell/conky.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:54:10

conky_dir="conky -q -c $HOME/.config/conky"

conky1="$conky_dir/klassiker_horizontal.conf"
conky2="$conky_dir/klassiker_slim_horizontal.conf"
conky3="$conky_dir/klassiker_vertical.conf"
conky4="$conky_dir/shortcuts_foreground_left.conf"
conky5="$conky_dir/shortcuts_foreground_middle.conf"
conky6="$conky_dir/shortcuts_foreground_right.conf"
conky7="$conky_dir/shortcuts_background_left.conf"
conky8="$conky_dir/shortcuts_background_middle.conf"
conky9="$conky_dir/shortcuts_background_right.conf"

choice=$1

# if no config given use vertical
[ -z "$1" ] && choice="vertical"

case "$choice" in
small)
    if [ "$(pgrep -f "$conky2")" ]; then
        # slim horizontal -> horizontal"
        kill "$(pgrep -f "$conky2")" && \
            $conky1 &
        exit 0
    elif [ "$(pgrep -f "$conky1")" ]; then
        # horizontal -> slim horizontal"
        kill "$(pgrep -f "$conky1")" && \
            $conky2 &
        exit 0
    else
        # start"
        $conky1 &
        exit 0
    fi
    ;;
large)
    if [ "$(pgrep -f "$conky3")" ]; then
        # vertical -> stop"
        kill "$(pgrep -f "$conky3")" && exit 0
    elif [ "$(pgrep -f "$conky2")" ]; then
        # slim horizontal -> vertical"
        kill "$(pgrep -f "$conky2")" && \
            $conky3 &
        exit 0
    elif [ "$(pgrep -f "$conky1")" ]; then
        # horizontal -> slim horizontal"
        kill "$(pgrep -f "$conky1")" && \
            $conky2 &
        exit 0
    else
        # start"
        $conky1 &
        exit 0
    fi
    ;;
horizontal)
    if [ "$(pgrep -f "conky -q -c $conky1")" ]; then
        # stop"
        kill "$(pgrep -f "conky -q -c $conky1")" &
        exit 0
    else
        # start"
        conky -q -c "$conky1" &
        exit 0
    fi
    ;;
slim-horizontal)
    if [ "$(pgrep -f "conky -q -c $conky2")" ]; then
        # stop"
        kill "$(pgrep -f "conky -q -c $conky2")" &
        exit 0
    else
        # start"
        conky -q -c "$conky2" &
        exit 0
    fi
    ;;
vertical)
    if [ "$(pgrep -f "$conky3")" ]; then
        # stop"
        kill "$(pgrep -f "$conky3")" &
        exit 0
    else
        # start"
        $conky3 &
        exit 0
    fi
    ;;
shortcutsforeground)
    if [ "$(pgrep -f "$conky6")" ]; then
        # stop"
        kill "$(pgrep -f "$conky4")" &
        kill "$(pgrep -f "$conky5")" &
        kill "$(pgrep -f "$conky6")" &
        exit 0
    else
        # start"
        $conky4 &
        $conky5 &
        $conky6 &
        exit 0
    fi
    ;;
shortcutsbackground)
    if [ "$(pgrep -f "$conky9")" ]; then
        # stop"
        kill "$(pgrep -f "$conky7")" &
        kill "$(pgrep -f "$conky8")" &
        kill "$(pgrep -f "$conky9")" &
        exit 0
    else
        # start"
        $conky7 &
        $conky8 &
        $conky9 &
        exit 0
    fi
    ;;
esac
