#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/screenlayout.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:42:29+0200

int=eDP1
ext=HDMI2

# if extrenal monitor is disconnected use internal screen else use default configuration
if xrandr | grep "$ext disconnected"; then
    xrandr --output "$ext" --off --output "$int" --auto
else
    "$HOME/.local/share/repos/shell/screenlayout/default.sh"
fi
