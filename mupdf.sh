#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/mupdf.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-08-13T03:07:16+0200

mupdf -I "$1" &

# wait max until the window opens
wait_for_max() {
    max_ds="$1"

    while ! wmctrl -l | grep -q "$2" \
        && [ "$max_ds" -ge 1 ]; do
            sleep .1
            max_ds=$((max_ds - 1))
    done

    [ "$max_ds" -ge 1 ] \
        || return 1
}

# send keystrokes with xdotool
command -v "xdotool" > /dev/null 2>&1 \
    && filename=$(basename "$1") \
    && wait_for_max 25 "$filename" \
    && xdotool search --name "$filename" \
        key --delay 0 --clearmodifiers Shift+z c Shift+p
