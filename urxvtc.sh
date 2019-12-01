#!/bin/sh

# path:       ~/coding/shell/urxvtc.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 14:41:49

# start urxvt daemon if not running and open urxvt client
urxvtc "$@"
if [ $? -eq 2 ]; then
    urxvtd -q -o -f
    urxvtc "$@"
fi
