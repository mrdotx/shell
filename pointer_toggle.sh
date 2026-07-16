#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/pointer_toggle.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:54:08+0200

# use standard C locale to avoid locale-specific issues and improve performance
export LC_ALL=C LANG=C

# config
notify_title="Toggle Pointer"
xinput_device="$1"

[ -z "$1" ] \
    && xinput list | grep -E '\[(master|slave|floating).*(pointer|master|slave)' \
    && exit

# helper
notification() {
    case "$1" in
        -n | --notify)
            notify-send \
                -t 2000 \
                -u low \
                "$notify_title" \
                "$xinput_device $2" \
                -h string:x-canonical-private-synchronous:"$xinput_device"
            ;;
    esac
}

device="$(xinput list \
    | sed -nre "/$xinput_device/s/.*id=([0-9]*).*/\1/p" \
    | head -n1 \
)"

status="$(xinput list-props "$device" \
    | grep "Device Enabled" \
    | grep -o "[01]$" \
)"

# main
case "$status" in
    1)
        xinput disable "$device"
        notification "$2" "DISABLED"
        ;;
    0)
        xinput enable "$device"
        notification "$2" "ENABLED"
        ;;
    *)
        notification "$2" "NOT FOUND"
        ;;
esac
