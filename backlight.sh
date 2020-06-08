#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/backlight.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-06-08T12:51:06+0200

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

option=$1
percent=$2

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$2" ] || [ $# -eq 0 ]; then
    printf "%s\n" "$help"
    exit 0
else
    max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    actual=$(cat /sys/class/backlight/intel_backlight/actual_brightness)

    if [ "$percent" -le 100 ] ; then
        percent=$((100 / percent))
    else
        printf "%s\n" "$help"
        exit 0
    fi
    factor=$((max / percent))
    max=$((factor * percent))

    unset new
    if [ "$option" = "-inc" ]; then
        new=$((actual + factor))
        if [ $new -ge $max ]; then
            new=$max
        fi
    elif [ "$option" = "-dec" ]; then
        new=$((actual - factor))
        if [ $new -le 0 ]; then
            new=0
        fi
    fi

    # set brighness
    printf "%s" "$new" > "/sys/class/backlight/intel_backlight/brightness"
fi
