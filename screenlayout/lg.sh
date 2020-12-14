#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/screenlayout/lg.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-12-13T12:13:58+0100

xrandr \
    --output eDP1 --primary \
    --mode 1920x1080 \
    --pos 0x1050 \
    --rotate normal \
    --output HDMI2 \
    --right-of eDP1 \
    --mode 1680x1050 \
    --pos 120x0 \
    --rotate normal \
    --output DP1 --off \
    --output HDMI1 --off \
    --output VIRTUAL1 --off
