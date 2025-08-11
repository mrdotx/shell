#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/urxvtc.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-08-11T04:51:20+0200

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
