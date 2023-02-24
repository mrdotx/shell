#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/urxvtc.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-02-24T18:02:37+0100

case "$1" in
    --kill)
        urxvtc -k
        ;;
    *)
        urxvtc "$@"
        [ $? -eq 2 ] \
            && urxvtd -q -o -f \
            && urxvtc "$@"
        ;;
esac
