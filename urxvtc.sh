#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/urxvtc.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-12-18T16:28:52+0100

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
