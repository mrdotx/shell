#!/bin/sh

# path:       ~/coding/shell/urxvtc.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-08 20:38:53

# start urxvt daemon if not running and open urxvt client
if [ "$(pgrep -x urxvtd)" ]; then
    urxvtc "$@"
else
    urxvtd -q -o -f
    urxvtc "$@"
fi
