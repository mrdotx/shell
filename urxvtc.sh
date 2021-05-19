#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/urxvtc.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-05-19T17:37:44+0200

daemon="urxvtd -q -o -f"
client="urxvtc"

run() {
    $1 -fx "$daemon" >/dev/null 2>&1
}

case "$1" in
    --kill)
        run "pgrep" \
            && run "pkill"
        ;;
    *)
        run "pgrep" \
            && $client "$@" \
            && exit 0

            $daemon
            $client "$@"
        ;;
esac
