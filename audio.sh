#!/bin/sh

# path:       ~/projects/shell/audio.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:52:30

script=$(basename "$0")
help="$script [-h/--help] -- script for audio output
  Usage:
    $script [-tog/-inc/-dec/-mute] [percent]

  Settings:
    [-tog]    = toggle output from analog to hdmi stereo
    [-mute]   = mute volume
    [-inc]    = increase in percent (0-100%)
    [-dec]    = decrease in percent (0-100%)
    [percent] = how much percent to increase/decrease the brightness

  Examples:
    $script -tog
    $script -mute
    $script -inc 10
    $script -dec 10"

direction=$1
percent=$2
pacmd_sink=$(pacmd list-sinks | grep "index:" | awk -F ': ' '{print $2}')

if [ "$1" = "-tog" ]; then
    pacmd_name=$(pacmd list-cards | grep "active profile:" | awk -F ': ' '{print $2}')
    if [ "$pacmd_name" = "<output:analog-stereo+input:analog-stereo>" ] || [ "$pacmd_name" = "<output:analog-stereo>" ]; then
        pacmd set-card-profile 0 "output:hdmi-stereo-extra1"
        pactl set-sink-volume $((pacmd_sink+2)) 100%
        exit 0
    else
        pacmd set-card-profile 0 "output:analog-stereo+input:analog-stereo"
        pactl set-sink-volume $((pacmd_sink+2)) 25%
        exit 0
    fi
elif [ "$1" = "-mute" ]; then
    pactl set-sink-mute "$pacmd_sink" toggle
    exit 0
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$2" ] || [ $# -eq 0 ]; then
    echo "$help"
    exit 0
fi

if [ "$direction" = "-inc" ]; then
    pactl set-sink-volume "$pacmd_sink" +"$percent"%
    exit 0
elif [ "$direction" = "-dec" ]; then
    pactl set-sink-volume "$pacmd_sink" -"$percent"%
    exit 0
fi
