#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/urxvtc.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-05-20T18:52:27+0200

case "$1" in
    --kill)
        urxvtc -k
        ;;
    *)
        daemon="urxvtd -q -o -f"

        pgrep -fx "$daemon" >/dev/null 2>&1 \
            && urxvtc "$@" \
            && exit 0

        $daemon
        urxvtc "$@"
        ;;
esac
