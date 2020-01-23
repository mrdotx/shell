#!/bin/sh

# path:       ~/projects/shell/scrot.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-23T10:14:24+0100

script=$(basename "$0")
help="$script [-h/--help] -- script for screenshots with scrot
  Usage:
    $script [-desk/-window/-select] [seconds]

  Settings:
    [-desk]         = full screen screenshot
    [-window]       = active window screenshot
    [-select]       = selection screenshot
    [seconds]       = the option -desk and -window can be used
                      with delay in seconds to screenshot

  Examples:
    $script -desk
    $script -desk 5
    $script -window
    $script -window 5
    $script -select"

sc_dir=$HOME/Schreibtisch
sc_file=screenshot-$(date +"%FT%T%z").png
sc_cmd="scrot $sc_dir/$sc_file"
sc_prev="sxiv $sc_dir/$sc_file"

if [ -n "$2" ]; then
    cmd="$sc_cmd -d $2"
else
    cmd="$sc_cmd"
fi

case "$1" in
    -desk)
        $cmd && $sc_prev
        ;;
    -window)
        $cmd -u && $sc_prev
        ;;
    -select)
        notify-send -i "$HOME/projects/shell/icons/screenshot.png" "scrot" "select an area for the screenshot" \
            & $sc_cmd -l style=solid,width=2 -s && $sc_prev
        ;;
    *)
        echo "$help"
        exit 0
esac
