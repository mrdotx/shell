#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/polybar.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# procedure {{{
# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
for m in $(polybar -m|tail -1|sed -e 's/:.*$//g'); do
    MONITOR=$m polybar i3 &
done

# Launch polybar on multiple monitors
#if type "xrandr"; then
#    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#       MONITOR=$m polybar i3 &
#    done
#else
#    polybar --reload i3 &
#fi
# }}}