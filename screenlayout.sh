#!/bin/sh

# path:       ~/coding/shell/screenlayout.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 14:05:31

internal=eDP1
external=HDMI2

# if extrenal monitor is disconnected use internal screen else use default configuration
if xrandr | grep "$external disconnected"; then
    xrandr --output "$external" --off --output "$internal" --auto
else
    "$HOME"/.screenlayout/default.sh
fi

# maintenance after setup displays
nitrogen --restore
