#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/backlight.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:30:48

# variables {{{
max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
val=$(cat /sys/class/backlight/intel_backlight/brightness)
dir=$1
# }}}

# procedure {{{
ten_percent=$(($max / 10))

unset new_brightness
if [ "$dir" == "up" ]; then
    new_brightness=$(($val + $ten_percent))
    if [ $new_brightness -gt $max ]; then
        new_brightness=$max
    fi
elif [ "$dir" == "down" ]; then
    new_brightness=$(($val - $ten_percent))
    if [ $new_brightness -lt 0 ]; then
        new_brightness=0
    fi
fi

sudo sh -c "echo $new_brightness >/sys/class/backlight/intel_backlight/brightness"
# }}}
