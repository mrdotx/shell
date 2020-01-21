#!/bin/sh

# path:       ~/projects/shell/i3_tiling.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-21T14:28:28+0100

script=$(basename "$0")
help="$script [-h/--help] -- script for optimal tiling i3 focused window
  Usage:
    $script [command]

  Settings:
    [command] = open application in new window. without command, the script
                runs in background and tile the windows automatic

  Examples:
    $script
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

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$help"
    exit 0
elif [ $# -ne 0 ]; then
    dim \
        && split \
        && "$@" &
else
    if [ "$(pgrep -f i3_tiling.sh | wc -l)" -gt 2 ]; then
        notify-send -i "$HOME/projects/shell/icons/i3.png" "i3" "optimal automatic tilings off"
        pkill -f i3_tiling.sh
    else
        notify-send -i "$HOME/projects/shell/icons/i3.png" "i3" "optimal automatic tilings on"
        wd=$(xdotool getwindowfocus getwindowpid)
        while true
        do
            if [ ! "$(xdotool getwindowfocus getwindowpid)" = "$wd" ]; then
                dim \
                    && split
            fi
            sleep 1
        done
    fi
fi
