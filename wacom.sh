#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/wacom.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-09-17T10:05:55+0200

list=$(xsetwacom list devices)

get_id() {
    printf "%s" "$list" \
        | awk -v device="$1" '$0 ~ device {print $8}'
}

get_display() {
    displays=$( \
        xrandr \
            | grep "connected" \
    )

    primary=$( \
        printf "%s" "$displays" \
            | grep "primary" \
            | cut -d " " -f1
    )

    secondary=$( \
        printf "%s" "$displays" \
            | grep -v "primary" \
            | head -n1 \
            | cut -d " " -f1
    )

    if [ -z "$primary" ]; then
        printf "%s\n" "$secondary"
    else
        printf "%s\n" "$primary"
    fi
}

get_dimension() {
    resolution=$( \
        xrandr \
        | sed -n "/^$1/,/\+/p" \
            | tail -n 1 \
            | awk '{print $1}' \
    )

    x=$( \
        printf "%s" "$resolution" \
            | sed "s/x.*//"
    )

    y=$( \
        printf "%s" "$resolution" \
            | sed "s/.*x//"
    )

    wacom_x=$( \
        xsetwacom get "$2" Area \
            | cut -d " " -f3
    )

    # reducing the drawing area height 15200 * 1080 / 1920 = 8550
    # default 0 0 15200 9500
    printf "0 0 %s %s\n" "$wacom_x" "$((wacom_x * y / x))"
}

set_wacom() {
    id=$(get_id "$1")
    display=$(get_display)
    dimension=$(get_dimension "$display" "$id")

    # map the drawing output to primary monitor
    xsetwacom set "$id" MapToOutput "$display"
    xsetwacom set "$id" Area "$dimension"
}

[ -n "$list" ] \
    && set_wacom "stylus" \
    && set_wacom "eraser"
