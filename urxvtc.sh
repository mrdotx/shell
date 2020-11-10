#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/urxvtc.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-11-10T20:23:53+0100

urxvtc "$@"
[ $? -eq 2 ] \
    && urxvtd -q -o -f \
    && urxvtc "$@"
