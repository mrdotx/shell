#!/bin/sh

# path:       ~/projects/shell/backlight.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:52:39

script=$(basename "$0")
help="$script [-h/--help] -- script to change intel backlight
  Usage:
    $script [-inc/-dec] [percent]

  Settings:
    [-inc]    = increase in percent (0-100%)
    [-dec]    = decrease in percent (0-100%)
    [percent] = how much percent to increase/decrease the brightness

  Examples:
    $script -inc 10
    $script -dec 10"

direction=$1
divider=$2

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$2" ] || [ $# -eq 0 ]; then
    echo "$help"
    exit 0
else
    maximal=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    actual=$(cat /sys/class/backlight/intel_backlight/actual_brightness)

    if [ "$divider" -lt 101 ] ; then
        divider=$((100 / divider))
    else
        echo "$help"
        exit 0
    fi
    factor=$((maximal / divider))
    maximal=$((factor * divider))

    unset new
    if [ "$direction" = "-inc" ]; then
        new=$((actual + factor))
        if [ $new -gt $maximal ]; then
            new=$maximal
        fi
    elif [ "$direction" = "-dec" ]; then
        new=$((actual - factor))
        if [ $new -lt 0 ]; then
            new=0
        fi
    fi

    # set brighness
    sudo sh -c "echo $new >/sys/class/backlight/intel_backlight/brightness"
fi
