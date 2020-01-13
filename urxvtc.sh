#!/bin/sh

# path:       ~/projects/shell/urxvtc.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:17:19+0100

# start urxvt daemon if not running and open urxvt client
if [ "$(pgrep -x urxvtd)" ]; then
    urxvtc "$@"
else
    urxvtd -q -o -f
    urxvtc "$@"
fi
