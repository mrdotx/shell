#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/screenshot.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:42:43+0200

script=$(basename "$0")
help="$script [-h/--help] -- script to make screenshots with maim
  Usage:
    $script [-desk/-window/-select] [seconds]

  Settings:
    [-desk]         = full screen screenshot
    [-window]       = active window screenshot
    [-select]       = selection screenshot
    [seconds]       = the option -desk and -window can be used
                      with delay in seconds to make screenshot

  Examples:
    $script -desk
    $script -desk 5
    $script -window
    $script -window 5
    $script -select"

sc_dir=$HOME/Schreibtisch
sc_file=screenshot-$(date +"%FT%T%z").png
sc_cmd="maim -B $sc_dir/$sc_file"
sc_prev="sxiv $sc_dir/$sc_file"

[ -n "$2" ] \
    && cmd="$sc_cmd -d $2" \
    || cmd="$sc_cmd"

case "$1" in
    -desk)
        $cmd && $sc_prev
        ;;
    -window)
        $cmd -i "$(xdotool getactivewindow)" && $sc_prev
        ;;
    -select)
        notify-send "maim" "select an area or window to screenshot" \
            & $sc_cmd -s && $sc_prev
        ;;
    *)
        printf "%s\n" "$help"
        exit 0
        ;;
esac
