#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/touchpad_toggle.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-04-24T08:04:42+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

device="$(xinput list \
    | grep -P '(?<= )[\w\s:]*(?i)(touchpad|synaptics)(?-i).*?(?=\s*id)' -o \
    | head -n1 \
)"

if [ "$(xinput list-props "$device" \
    | grep -P ".*Device Enabled.*\K.(?=$)" -o)" = "1" ]; then
        xinput disable "$device"
else
    xinput enable "$device"
fi
