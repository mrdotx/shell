#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/screenlayout.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-08-26T10:41:31+0200

# config
primary="HDMI2"
secondary="eDP1"

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to set screenlayout
  Usage:
    $script [--defaults] [parameter]

  Settings:
    [--defaults] = list of default settings for dmenu
    [parameter]  = semicolon separated
                   1) primary mode (default: 1920x1080)
                   2) primary position (default: 0x0)
                   3) primary rate (default: 60)
                   4) primary rotate (default: normal)
                   5) secondary mode (default: 1920x1080)
                   6) secondary position (default: 1920x0)
                   7) secondary rate (default: 60)
                   8) secondary rotate (default: normal)

                   rotate = normal, left, right, inverted

  Examples:
    $script
    $script --list
    $script \"1920x1080;0x0;75;right;1920x1080;1920x0;60;\"
    $script \";;75;;;\"

  Config:
    primary = $primary
    secondary = $secondary"

single_monitor() {
    xrandr \
        --output "$secondary" --auto --primary \
        --output "$primary" --off \
        --output DP1 --off \
        --output HDMI1 --off \
        --output VIRTUAL1 --off
}

dual_monitor() {
    pri_mode=$(printf "%s" "$1" | cut -d ';' -f1)
    pri_pos=$(printf "%s" "$1" | cut -d ';' -f2)
    pri_rate=$(printf "%s" "$1" | cut -d ';' -f3)
    pri_rotate=$(printf "%s" "$1" | cut -d ';' -f4)
    sec_mode=$(printf "%s" "$1" | cut -d ';' -f5)
    sec_pos=$(printf "%s" "$1" | cut -d ';' -f6)
    sec_rate=$(printf "%s" "$1" | cut -d ';' -f7)
    sec_rotate=$(printf "%s" "$1" | cut -d ';' -f8)

    xrandr \
        --output "$primary" --auto --primary \
        --mode "${pri_mode:-1920x1080}" \
        --pos "${pri_pos:-0x0}" \
        --rate "${pri_rate:-60}" \
        --rotate "${pri_rotate:-normal}" \
        --output "$secondary" --auto \
        --mode "${sec_mode:-1920x1080}" \
        --pos "${sec_pos:-1920x0}" \
        --rate "${sec_rate:-60}" \
        --rotate "${sec_rotate:-normal}" \
        --output DP1 --off \
        --output HDMI1 --off \
        --output VIRTUAL1 --off
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    --defaults)
        printf "%s\n" \
            "1920x1080;0x0;60;;1920x1080;1920x0;60;" \
            "1920x1080;0x0;60;right;1920x1080;1920x0;60;" \
            "1920x1080;0x0;75;;1920x1080;1920x0;60;" \
            "1920x1080;0x0;75;right;1920x1080;1920x0;60;" \
            "1920x1080;1680x1050;;60;0x1050;120x0;60;"
        ;;
    *)
        if xrandr | grep "$primary disconnected"; then
            single_monitor
        else
            dual_monitor "$1"
        fi
        ;;
esac
