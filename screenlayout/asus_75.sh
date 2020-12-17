#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/screenlayout/asus_75.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-12-17T09:20:06+0100

xrandr \
    --output eDP1 --primary \
    --mode 1920x1080 \
    --pos 0x1080 \
    --rotate normal \
    --output HDMI2 \
    --mode 1920x1080 \
    --rate 74.99 \
    --pos 0x0 \
    --rotate normal \
    --output DP1 --off \
    --output HDMI1 --off \
    --output VIRTUAL1 --off
