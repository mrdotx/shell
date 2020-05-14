#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/wallpaper.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:44:46+0200

wp_file="$HOME/.local/share/wallpaper.jpg"

[ -f "$1" ] \
    && convert "$1" "$wp_file" \
    && systemctl --user restart xwallpaper.service \
    && notify-send -i "$wp_file" "xwallpaper" "wallpaper changed!"
