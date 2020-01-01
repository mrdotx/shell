#!/bin/sh

# path:       ~/projects/shell/polybar.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-01 10:38:42

# toggle for polybar bars
if [ -n "$1" ]; then
    bar="$1"
elif [ "$(pgrep -xf "polybar i3")" ]; then
    bar="i3stat"
elif [ "$(pgrep -xf "polybar i3stat")" ]; then
    bar="i3"
else
    bar="i3"
fi

# terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# launch polybar
#for m in $(polybar -m | sed -e 's/:.*$//g'); do
for m in $(polybar -m | tail -1 | sed -e 's/:.*$//g'); do
    MONITOR=$m polybar $bar &
done
