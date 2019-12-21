#!/bin/sh

# path:       ~/projects/shell/urxvtc.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 15:02:37

# start urxvt daemon if not running and open urxvt client
if [ "$(pgrep -x urxvtd)" ]; then
    urxvtc "$@"
else
    urxvtd -q -o -f
    urxvtc "$@"
fi
