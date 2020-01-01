#!/bin/sh

# path:       ~/projects/shell/polybar.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-01 17:42:15

# toggle for polybar bars
if [ -n "$1" ]; then
    bar="$1"
elif [ "$(pgrep -xf "polybar i3_btm")" ]; then
    bar="i3"
elif [ "$(pgrep -xf "polybar i3")" ]; then
    bar_top="i3_top"
    bar_btm="i3_btm"
else
    bar="i3"
fi

# terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# launch polybar
if [ -z $bar_btm ]; then
    for m in $(polybar -m | tail -1 | sed -e 's/:.*$//g'); do
        MONITOR=$m polybar $bar &
    done
else
    for m in $(polybar -m | tail -1 | sed -e 's/:.*$//g'); do
        MONITOR=$m polybar $bar_top &
        MONITOR=$m polybar $bar_btm &
    done
fi
