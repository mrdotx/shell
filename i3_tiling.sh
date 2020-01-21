#!/bin/sh

# path:       ~/projects/shell/i3_tiling.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-21T11:00:21+0100

script=$(basename "$0")
help="$script [-h/--help] -- script for optimal tiling i3 focused window
  Usage:
    $script [command]

  Examples:
    $script firefox
    $script $TERMINAL"

dim() {
    w_d=$(xdotool getwindowfocus getwindowgeometry | grep Geometry: | awk -F ': ' '{print $2}')
    x=$(echo "$w_d" | awk -F 'x' '{print $1}')
    y=$(echo "$w_d" | awk -F 'x' '{print $2}')
}

split() {
    if [ "$x" -gt "$y" ]; then
        i3-msg -q split h
    elif [ "$x" -lt "$y" ]; then
        i3-msg -q split v
    elif [ "$x" -eq "$y" ]; then
        i3-msg -q split v
    fi
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -eq 0 ]; then
    echo "$help"
    exit 0
else
    dim \
        && split \
        && "$@" &
fi
