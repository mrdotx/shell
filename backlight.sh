#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/backlight.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

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