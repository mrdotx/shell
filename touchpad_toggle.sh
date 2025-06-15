#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/touchpad_toggle.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-06-15T03:20:03+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
message_title="Touchpad"

# helper
notification() {
    case "$1" in
        -n | --notify)
            notify-send \
                -t 2000 \
                -u low \
                "$message_title $2" \
                -h string:x-canonical-private-synchronous:"$message_title"
            ;;
    esac
}

device="$(xinput list \
    | sed -nre '/[tT]ouch[pP]ad/s/.*id=([0-9]*).*/\1/p' \
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
        notification "$1" "DISABLED"
        ;;
    0)
        xinput enable "$device"
        notification "$1" "ENABLED"
        ;;
    *)
        notification "$1" "NOT FOUND"
        ;;
esac
