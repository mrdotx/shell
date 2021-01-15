#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/screenlayout.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-01-15T13:59:16+0100

# config
internal="eDP1"
external="HDMI2"

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to set screenlayout
  Usage:
    $script [--list] [parameter]

  Settings:
    [--list]    = list of defined settings for dmenu
    [parameter] = semicolon separated list
                  1) internal mode (default: 1920x1080)
                  2) internal position (default: 0x1080)
                  3) external mode (default: 1920x1080)
                  4) external position (default: 0x0)
                  5) external rate (default: 75)
                  6) external orientation (default: above)

  Examples:
    $script
    $script --list
    $script \"1920x1080;0x1080;1920x1080;0x0;75;above\"
    $script \";;;;60;\"

  Config:
    internal = $internal
    external = $external"

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    --list)
        printf "%s\n" \
            "1920x1080;0x1080;1920x1080;0x0;75;above" \
            "1920x1080;0x1080;1920x1080;0x0;60;above" \
            "1920x1080;0x1050;1680x1050;120x0;60;right-of"
        ;;
    *)
        # if extrenal monitor is disconnected use internal screen else use configuration
        if xrandr | grep "$external disconnected"; then
            xrandr \
                --output "$internal" --auto \
                --output "$external" --off \
                --output DP1 --off \
                --output HDMI1 --off \
                --output VIRTUAL1 --off
        else
            pri_mode=$(printf "%s" "$1" | cut -d ';' -f1)
            pri_pos=$(printf "%s" "$1" | cut -d ';' -f2)
            sec_mode=$(printf "%s" "$1" | cut -d ';' -f3)
            sec_pos=$(printf "%s" "$1" | cut -d ';' -f4)
            sec_rate=$(printf "%s" "$1" | cut -d ';' -f5)
            sec_side=$(printf "%s" "$1" | cut -d ';' -f6)

            xrandr \
                --output "$internal" --primary \
                --mode "${pri_mode:-1920x1080}" \
                --pos "${pri_pos:-0x1080}" \
                --output "$external" \
                --mode "${sec_mode:-1920x1080}" \
                --pos "${sec_pos:-0x0}" \
                --rate "${sec_rate:-75}" \
                --"${sec_side:-above}" "$internal" \
                --output DP1 --off \
                --output HDMI1 --off \
                --output VIRTUAL1 --off
        fi
        ;;
esac
