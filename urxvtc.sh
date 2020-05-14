#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/urxvtc.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:44:25+0200

# start urxvt daemon if not running and open urxvt client
if [ "$(pgrep -x urxvtd)" ]; then
    urxvtc "$@"
else
    urxvtd -q -o -f
    urxvtc "$@"
fi
