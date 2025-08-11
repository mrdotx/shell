#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/archive/ssh_exec.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-08-11T04:54:04+0200

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
