#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/urxvtc.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-07 22:20:06

# start urxvt daemon if not running and open urxvt client
urxvtc "$@"
if [ $? -eq 2 ]; then
    urxvtd -q -o -f
    urxvtc "$@"
fi
