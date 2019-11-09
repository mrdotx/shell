#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/screenlayout.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-07 22:39:36

internal=eDP1
external=HDMI2

# if extrenal monitor is disconnected use internal screen else use default configuration
if xrandr | grep "$external disconnected"; then
    xrandr --output "$external" --off --output "$internal" --auto
else
    "$HOME"/.screenlayout/default.sh
fi
