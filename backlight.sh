#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/backlight.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-23 16:08:00

direction=$1
divider=$2

# change intel backlight
if [[ $1 == "-h" || $1 == "--help" || -z $2 || $# -eq 0 ]]; then
    echo "Usage:"
    echo "	backlight.sh [-inc/-dec] [divider]"
    echo
    echo "Setting:"
    echo "  -inc        increase"
    echo "  -dec        decrease"
    echo "  divider     how often divide the maximum brightness value"
    echo
    echo "Example:"
    echo "	backlight.sh -inc 20"
    echo "	backlight.sh -dec 20"
    echo
    exit 0
else
    maximal=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    actual=$(cat /sys/class/backlight/intel_backlight/actual_brightness)

    factor=$(($maximal / $divider))
    maximal=$(($factor * $divider))

    unset new
    if [ "$direction" == "-inc" ]; then
        new=$(($actual + $factor))
        if [ $new -gt $maximal ]; then
            new=$maximal
        fi
    elif [ "$direction" == "-dec" ]; then
        new=$(($actual - $factor))
        if [ $new -lt 0 ]; then
            new=0
        fi
    fi

    # set brighness
    sudo sh -c "echo $new >/sys/class/backlight/intel_backlight/brightness"
fi
