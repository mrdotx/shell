#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/backlight.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:39:19+0200

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

if [ ! "$(id -u)" = 0 ]; then
   printf "this script needs root privileges to run\n"
   exit 1
fi

opt=$1
div=$2

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$2" ] || [ $# -eq 0 ]; then
    printf "%s\n" "$help"
    exit 0
else
    max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    act=$(cat /sys/class/backlight/intel_backlight/actual_brightness)

    if [ "$div" -le 100 ] ; then
        div=$((100 / div))
    else
        printf "%s\n" "$help"
        exit 0
    fi
    fac=$((max / div))
    max=$((fac * div))

    unset new
    if [ "$opt" = "-inc" ]; then
        new=$((act + fac))
        if [ $new -ge $max ]; then
            new=$max
        fi
    elif [ "$opt" = "-dec" ]; then
        new=$((act - fac))
        if [ $new -le 0 ]; then
            new=0
        fi
    fi

    # set brighness
    printf "%s" "$new" > "/sys/class/backlight/intel_backlight/brightness"
fi
