#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/ssh_exec.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-12-15T11:49:58+0100

remote_host="$1"
shift

case "$remote_host" in
    "$(hostname)")
        "$@"
        ;;
    *)
        ssh -t "$remote_host" "$@"
        ;;
esac
