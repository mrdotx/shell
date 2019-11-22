#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/polybar.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-22 00:26:26

# toggle for polybar bars
if [ "$(pgrep -xf "polybar i3slim")" ]; then
    bar="i3"
elif [ "$(pgrep -xf "polybar i3")" ]; then
    bar="i3slim"
else
    bar="i3slim"
fi

# terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# launch polybar
for m in $(polybar -m | tail -1 | sed -e 's/:.*$//g'); do
    MONITOR=$m polybar $bar &
done

# launch polybar on multiple monitors
#if type "xrandr"; then
#    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#        MONITOR=$m polybar $bar &
#    done
#else
#    polybar --reload $bar &
#fi
