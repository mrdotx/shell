#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/screenlayout.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-06-08T12:54:31+0200

internal=eDP1
external=HDMI2

# if extrenal monitor is disconnected use internal screen else use default configuration
if xrandr | grep "$external disconnected"; then
    xrandr --output "$external" --off --output "$internal" --auto
else
    "$HOME/.local/share/repos/shell/screenlayout/default.sh"
fi
