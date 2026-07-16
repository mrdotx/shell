#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/urxvtc.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:54:43+0200

case "$1" in
    --kill)
        urxvtc -k
        ;;
    *)
        daemon="urxvtd -q -o -f"

        pgrep -fx "$daemon" >/dev/null 2>&1 \
            || $daemon

        urxvtc "$@"
        ;;
esac
