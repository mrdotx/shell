#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/ssh_exec.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-01-06T10:48:02+0100

remote_host="$1"
shift

case "$remote_host" in
    "$(uname -n)")
        "$@"
        ;;
    *)
        ssh -t "$remote_host" "$@"
        ;;
esac
