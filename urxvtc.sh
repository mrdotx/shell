#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/urxvtc.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-01-15T13:59:43+0100

daemon="urxvtd -q -o -f"

if [ "$(pgrep -fx "$daemon")" ]; then
    urxvtc "$@"
else
    $daemon
    urxvtc "$@"
fi
