#!/bin/sh

# path:       ~/projects/shell/polybar.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-08 20:12:45

pri=$(polybar -m | grep "(primary)" | sed -e 's/:.*$//g')
sec=$(polybar -m | grep -v "(primary)" | sed -e 's/:.*$//g')

# toggle the bars
if [ -n "$1" ]; then
    bar_pri="$1"
elif [ "$(pgrep -xf "polybar i3_sec")" ] \
    || [ "$(pgrep -xf "polybar i3_pri_btm")" ] \
    || [ "$(pgrep -xf "polybar i3_sec_top")" ]; then
    bar_pri="i3_pri"
elif [ "$(pgrep -xf "polybar i3_pri")" ]; then
    bar_sec="i3_sec"
    bar_pri_btm="i3_pri_btm"
    bar_sec_top="i3_sec_top"
else
    if [ "$(polybar -m | wc -l)" = 2 ]; then
        bar_sec="i3_sec"
        bar_pri_btm="i3_pri_btm"
        bar_sec_top="i3_sec_top"
    else
        bar_pri="i3_pri"
    fi
fi

# terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# launch polybar and write errorlog to tmp
if [ -z $bar_sec ]; then
        echo "---" | tee -a /tmp/polybar_$bar_pri.log
        MONITOR=$pri polybar $bar_pri  >>/tmp/polybar_$bar_pri.log 2>&1 &
else
    if [ "$(polybar -m | wc -l)" = 2 ]; then
        echo "---" | tee -a /tmp/polybar_$bar_sec.log /tmp/polybar_$bar_sec_top.log
        MONITOR=$pri polybar $bar_sec >>/tmp/polybar_$bar_sec.log 2>&1 &
        MONITOR=$sec polybar $bar_sec_top >>/tmp/polybar_$bar_sec_top.log 2>&1 &
    else
        echo "---" | tee -a /tmp/polybar_$bar_sec.log /tmp/polybar_$bar_pri_btm.log
        MONITOR=$pri polybar $bar_sec >>/tmp/polybar_$bar_sec.log 2>&1 &
        MONITOR=$pri polybar $bar_pri_btm >>/tmp/polybar_$bar_pri_btm.log 2>&1 &
    fi
fi
