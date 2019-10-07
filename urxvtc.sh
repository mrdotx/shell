#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/urxvtc.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

urxvtc "$@"
if [ $? -eq 2 ]; then
    urxvtd -q -o -f
    urxvtc "$@"
fi
