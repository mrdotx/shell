#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/urxvtc.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-11-14T10:11:19+0100

daemon="urxvtd -q -o -f"

if [ "$(pgrep -fx "$daemon")" ]; then
    urxvtc "$@"
else
    $daemon
    urxvtc "$@"
fi
