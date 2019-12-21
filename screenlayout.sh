#!/bin/sh

# path:       ~/projects/shell/screenlayout.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:59:54

int=eDP1
ext=HDMI2

# if extrenal monitor is disconnected use internal screen else use default configuration
if xrandr | grep "$ext disconnected"; then
    xrandr --output "$ext" --off --output "$int" --auto
else
    "$HOME/.screenlayout/default.sh"
fi

# maintenance after setup displays
nitrogen --restore
