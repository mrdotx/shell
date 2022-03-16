#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/wallpaper.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-03-16T08:07:40+0100

xresource="$HOME/.config/X11/Xresources"
config="$HOME/.config/X11/modules/wallpaper"

script=$(basename "$0")
help="$script [-h/--help] -- wrapper script to set wallpaper
  Usage:
    $script [--random] <path/file>

  Settings:
    without given settings, load wallpaper from xresources
    [folder]   = set random picture from folder as wallpaper and save folder
                 path to xresources
    [file]     = set picture as wallpaper and save filename to xresources
    [--random] = set random picture based on saved <path/file> from xresources

  Examples:
    $script
    $script $HOME/Pictures/Wallpaper
    $script $HOME/Pictures/Wallpaper/Dark_Blue/pcb.jpg
    $script --random

  Config:
    xresource = $xresource
    config    = $config"

xresource() {
    case "$1" in
        get_value)
            printf "%s" "$(xrdb -query \
                | grep wallpaper."$2": \
                | cut -f2)"
            ;;
        set_value)
            sed -i "/wallpaper.uri:/c\wallpaper.$2:  $3" "$config"
            xrdb -merge "$xresource"
            ;;
    esac
}

random_pic() {
    find "$1" -type f \
        | shuf -n 1
}

random_uri() {
    uri="$(xresource get_value uri)"
    if [ -d "$uri" ]; then \
        uri="$(random_pic "$uri")"
    else
        uri="$(random_pic "$(dirname "$uri")")"
    fi
    printf "%s" "$uri"
}

process_uri() {
    if [ -d "$1" ]; then
        uri="$(random_pic "$1")"
        xresource set_value uri "$1"
    elif [ -f "$1" ]; then
        uri="$1"
        xresource set_value uri "$1"
    else
        uri="$(xresource get_value uri)"
        [ -d "$uri" ] \
            && uri="$(random_pic "$uri")"
    fi
    printf "%s" "$uri"
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    --random)
        $(xresource get_value tool) "$(random_uri)" >/dev/null 2>&1
        ;;
    *)
        $(xresource get_value tool) "$(process_uri "$1")" >/dev/null 2>&1
        ;;
esac
