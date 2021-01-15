#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/touchpad.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-01-15T13:59:34+0100

device="$(xinput list \
        | grep -P '(?<= )[\w\s:]*(?i)(touchpad|synaptics)(?-i).*?(?=\s*id)' -o \
        | head -n1 \
    )"

if [ "$(xinput list-props "$device" | grep -P ".*Device Enabled.*\K.(?=$)" -o)" = "1" ]; then
    xinput disable "$device"
else
    xinput enable "$device"
fi
