#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/archive/screenshot.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-04-11T22:22:40+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
screenshot_directory="$HOME/Desktop"
screenshot_file="$screenshot_directory/screenshot-$(date +"%FT%T%z").png"
screenshot_command="maim -Buq $screenshot_file"
screenshot_preview="nsxiv $screenshot_file"

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to make screenshots with maim
  Usage:
    $script [--desktop/--window/--selection] [seconds]

  Settings:
    [--desktop]   = full screen screenshot
    [--window]    = active window screenshot
    [--selection] = selection screenshot
    [seconds]     = the option -desk and -window can be used
                    with delay in seconds to make screenshot

  Examples:
    $script --desktop
    $script --window
    $script --selection
    $script --desktop 5
    $script --window 5"

[ -n "$2" ] \
    && screenshot_command="$screenshot_command -d $2"

case "$1" in
    --desktop)
        $screenshot_command \
            && $screenshot_preview &
        ;;
    --window)
        $screenshot_command -i "$(xdotool getactivewindow)" \
            && $screenshot_preview &
        ;;
    --selection)
        notify-send \
            -u low \
            "maim" \
            "select an area or a window for the screenshot"
        $screenshot_command -so \
            && $screenshot_preview &
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac
