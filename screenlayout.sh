#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/screenlayout.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-07-08T07:58:37+0200

# config
primary="eDP1"
secondary="HDMI2"

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to set screenlayout
  Usage:
    $script [--list] [parameter]

  Settings:
    [--list]    = list of defined settings for dmenu
    [parameter] = semicolon separated
                  1) primary mode (default: 1920x1080)
                  2) primary position (default: 1920x0)
                  3) secondary mode (default: 1920x1080)
                  4) secondary position (default: 0x0)
                  5) secondary rate (default: 74.99)

  Examples:
    $script
    $script --list
    $script \"1920x1080;0x1080;1920x1080;0x0;74.99\"
    $script \";;;;60\"

  Config:
    primary = $primary
    secondary = $secondary"

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    --list)
        printf "%s\n" \
            "1920x1080;1920x0;1920x1080;0x0;74.99" \
            "1920x1080;1920x0;1920x1080;0x0;60" \
            "1920x1080;0x1050;1680x1050;120x0;60"
        ;;
    *)
        # if extrenal monitor is disconnected use primary screen else use configuration
        if xrandr | grep "$secondary disconnected"; then
            xrandr \
                --output "$primary" --auto \
                --output "$secondary" --off \
                --output DP1 --off \
                --output HDMI1 --off \
                --output VIRTUAL1 --off
        else
            pri_mode=$(printf "%s" "$1" | cut -d ';' -f1)
            pri_pos=$(printf "%s" "$1" | cut -d ';' -f2)
            sec_mode=$(printf "%s" "$1" | cut -d ';' -f3)
            sec_pos=$(printf "%s" "$1" | cut -d ';' -f4)
            sec_rate=$(printf "%s" "$1" | cut -d ';' -f5)

            xrandr \
                --output "$primary" --primary \
                --mode "${pri_mode:-1920x1080}" \
                --pos "${pri_pos:-1920x0}" \
                --output "$secondary" \
                --mode "${sec_mode:-1920x1080}" \
                --pos "${sec_pos:-0x0}" \
                --rate "${sec_rate:-74.99}" \
                --output DP1 --off \
                --output HDMI1 --off \
                --output VIRTUAL1 --off
        fi
        ;;
esac
