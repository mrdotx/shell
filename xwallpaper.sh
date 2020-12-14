#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/xwallpaper.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-11-19T11:34:28+0100

config="$HOME/.config/xorg/xwallpaper"
xresource="$HOME/.config/xorg/Xresources"

# get random picture from directory
rnd_pic() {
    find "$1" -type f | shuf -n 1
}

# get/set xresource value
xresource() {
    case "$1" in
        get_value)
            printf "%s" "$(xrdb -query \
                | grep Xwallpaper."$2": \
                | cut -f2)"
            ;;
        set_value)
            sed -i "/Xwallpaper.uri:/c\Xwallpaper.$2:         $3" "$config"
            xrdb -merge "$xresource"
            ;;
    esac
}

if [ -d "$1" ]; then
    uri="$(rnd_pic "$1")"
    xresource set_value uri "$1"
elif [ -f "$1" ]; then
    uri="$1"
    xresource set_value uri "$1"
else
    uri="$(xresource get_value uri)"

    [ -d "$uri" ] \
        && uri="$(rnd_pic "$uri")"
fi

options="$(xresource get_value options)"

eval xwallpaper "$options" "$uri"