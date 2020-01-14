#!/bin/sh

# path:       ~/projects/shell/conky.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-14T17:32:07+0100

conky_dir="conky -q -c $HOME/.config/conky"

conky1="$conky_dir/klassiker_horizontal.conf"
conky2="$conky_dir/klassiker_slim_horizontal.conf"
conky3="$conky_dir/klassiker_vertical.conf"

choice=$1

# if no config given use vertical
[ -z "$1" ] && choice="vertical"

case "$choice" in
small)
    if [ "$(pgrep -f "$conky2")" ]; then
        # slim horizontal -> horizontal"
        kill "$(pgrep -f "$conky2")" \
            && $conky1 &
        exit 0
    elif [ "$(pgrep -f "$conky1")" ]; then
        # horizontal -> slim horizontal"
        kill "$(pgrep -f "$conky1")" \
            && $conky2 &
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
        kill "$(pgrep -f "$conky3")" \
            && exit 0
    elif [ "$(pgrep -f "$conky2")" ]; then
        # slim horizontal -> vertical"
        kill "$(pgrep -f "$conky2")" \
            && $conky3 &
        exit 0
    elif [ "$(pgrep -f "$conky1")" ]; then
        # horizontal -> slim horizontal"
        kill "$(pgrep -f "$conky1")" \
            && $conky2 &
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
esac
