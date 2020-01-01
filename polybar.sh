#!/bin/sh

# path:       ~/projects/shell/polybar.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-01 20:08:07

pri=$(polybar -m | grep "(primary)" | sed -e 's/:.*$//g')
sec=$(polybar -m | grep -v "(primary)" | sed -e 's/:.*$//g')

# toggle for the bars
if [ -n "$1" ]; then
    bar="$1"
elif [ "$(pgrep -xf "polybar i3_top")" ] || [ "$(pgrep -xf "polybar i3_bottom")" ]; then
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

# launch polybar and write errorlog to tmp
if [ -z $bar_btm ]; then
        echo "---" | tee -a /tmp/polybar_$bar.log
        MONITOR=$pri polybar $bar  >>/tmp/polybar_$bar.log 2>&1 &
else
    if [ "$(polybar -m | wc -l)" = 2 ]; then
        echo "---" | tee -a /tmp/polybar_$bar_top.log /tmp/polybar_$bar_btm.log
        MONITOR=$pri polybar $bar_top >>/tmp/polybar_$bar_top.log 2>&1 &
        MONITOR=$sec polybar $bar_btm >>/tmp/polybar_$bar_btm.log 2>&1 &
    else
        echo "---" | tee -a /tmp/polybar_$bar_top.log /tmp/polybar_$bar_btm.log
        MONITOR=$pri polybar $bar_top >>/tmp/polybar_$bar_top.log 2>&1 &
        MONITOR=$pri polybar $bar_btm >>/tmp/polybar_$bar_btm.log 2>&1 &
    fi
fi
