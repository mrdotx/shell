#!/bin/sh

# path:       ~/projects/shell/scrot.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:16:49+0100

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

scrot_dir=$HOME/Downloads
scrot_file=screenshot-$(date +"%FT%T%z").jpg
scrot_cmd="scrot $scrot_dir/$scrot_file"

if [ -n "$2" ]; then
    cmd="$scrot_cmd -d $2"
else
    cmd="$scrot_cmd"
fi

case "$1" in
    -desk)
        $cmd \
            && notify-send -i "$HOME/projects/shell/icons/screenshot.png" "scrot" "screenshot has been saved to $scrot_dir/$scrot_file"

        exit 0
        ;;
    -window)
        $cmd -u \
            && notify-send -i "$HOME/projects/shell/icons/screenshot.png" "scrot" "screenshot has been saved to $scrot_dir/$scrot_file"
        exit 0
        ;;
    -select)
        notify-send -i "$HOME/projects/shell/icons/screenshot.png" "scrot" "select an area for the screenshot" \
            & $scrot_cmd -s \
            && notify-send -i "$HOME/projects/shell/icons/screenshot.png" "scrot" "screenshot has been saved in $scrot_dir/$scrot_file"
        exit 0
        ;;
    *)
        echo "$help"
        exit 0
esac
