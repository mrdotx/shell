#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/wallpaper.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-04-19T19:45:42+0200

xresource="$HOME/.config/X11/Xresources"
config="$HOME/.config/X11/Xresources.d/wallpaper"

script=$(basename "$0")
help="$script [-h/--help] -- wrapper script to set wallpaper
  Usage:
    $script [--color] [--random] <path/file>

  Settings:
    without given settings, load wallpaper from xresources
    [folder]   = set random picture from folder as wallpaper and save folder
                 path to xresources
    [file]     = set picture as wallpaper and save filename to xresources
    [--color]  = set colored background by hex value (default: #000000)
    [--random] = set random picture based on saved <path/file> from xresources

  Examples:
    $script
    $script $HOME/Pictures/Wallpaper
    $script $HOME/Pictures/Wallpaper/Dark_Blue/pcb.jpg
    $script --color #4185d7
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

color_uri() {
    uri="/tmp/wallpaper-color.png"

    convert xc:"${1:-#000000}" -resize 1920x1080! "$uri"

    printf "%s" "$uri"
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
    --color)
        $(xresource get_value tool) "$(color_uri "$2")" >/dev/null 2>&1
        ;;
    --random)
        $(xresource get_value tool) "$(random_uri)" >/dev/null 2>&1
        ;;
    *)
        $(xresource get_value tool) "$(process_uri "$1")" >/dev/null 2>&1
        ;;
esac
