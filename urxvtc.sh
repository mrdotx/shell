#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/urxvtc.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:34:20

urxvtc "$@"
if [ $? -eq 2 ]; then
    urxvtd -q -o -f
    urxvtc "$@"
fi
