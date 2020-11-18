#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/xwallpaper.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-11-18T18:32:13+0100

# set xresources uri
set_uri() {
    file="$HOME/.config/xorg/xwallpaper"
    sed -i "/Xwallpaper.uri:/c\Xwallpaper.uri:     \"$1\"" "$file"
    xrdb -merge "$HOME/.config/xorg/Xresources"
}

if [ -d "$1" ]; then
    uri="$(find "$1" -type f | shuf -n 1)"
    set_uri "$1"
elif [ -f "$1" ]; then
    uri="$1"
    set_uri "$1"
else
    # get xresources uri
    uri=$(printf "%s" "$(xrdb -query \
        | grep Xwallpaper.uri: \
        | cut -f2)" \
    )

    [ -d "$uri" ] \
        && uri="$(find "$uri" -type f | shuf -n 1)"
fi

# get xresources options
options=$(printf "%s" "$(xrdb -query \
    | grep Xwallpaper.options: \
    | cut -f2)" \
)

eval xwallpaper "$options" "$uri"
