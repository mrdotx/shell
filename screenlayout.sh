#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/screenlayout.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-12-17T16:09:18+0100

internal="eDP1"
external="HDMI2"
default="1920x1080_75"

case "$1" in
    list)
        printf "%s\n" \
            "default" \
            "1920x1080_75" \
            "1920x1080" \
            "1680x1050"
        ;;
    1920x1080_75)
        xrandr \
            --output "$internal" --primary \
            --mode 1920x1080 \
            --pos 0x1080 \
            --output "$external" \
            --mode 1920x1080 \
            --rate 74.99 \
            --pos 0x0
        ;;
    1920x1080)
        xrandr \
            --output "$internal" --primary \
            --mode 1920x1080 \
            --pos 0x1080 \
            --output "$external" \
            --mode 1920x1080 \
            --pos 0x0
        ;;
    1680x1050)
        xrandr \
            --output "$internal" --primary \
            --mode 1920x1080 \
            --pos 0x1050 \
            --output "$external" \
            --right-of "$internal" \
            --mode 1680x1050 \
            --pos 120x0 \
        ;;
    *)
        # if extrenal monitor is disconnected use internal screen else use default configuration
        if xrandr | grep "$external disconnected"; then
            xrandr --output "$external" --off --output "$internal" --auto
        else
            $0 $default
        fi
        ;;
esac
