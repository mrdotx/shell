#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/polybar.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-13 12:46:20

# terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# launch polybar
for m in $(polybar -m | tail -1 | sed -e 's/:.*$//g'); do
    MONITOR=$m polybar i3 &
done

# launch polybar on multiple monitors
#if type "xrandr"; then
#    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#        MONITOR=$m polybar i3 &
#    done
#else
#    polybar --reload i3 &
#fi
