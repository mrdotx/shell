#!/bin/sh

# path:       ~/projects/shell/polybar.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:55:26

# toggle for polybar bars
if [ -n "$1" ]; then
    bar="$1"
elif [ "$(pgrep -xf "polybar i3slim")" ]; then
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
