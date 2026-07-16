#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/archive/ssh_exec.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:51:34+0200

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
