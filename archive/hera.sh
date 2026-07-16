#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/archive/hera.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:50:51+0200

# use standard C locale to avoid locale-specific issues and improve performance
export LC_ALL=C LANG=C

case "$1" in
wakeup)
    # send magic paket to hera
    wake_on_lan.sh 00:08:9b:c6:99:76
    ;;
poweroff)
    # send poweroff commands per ssh
    ssh -t admin@hera "/sbin/poweroff"
    ;;
status)
    # call host status script
    status="$("$HOME"/Projects/repos/shell/archive/host_status.sh hera)"

    case $status in
        *offline*)
            printf "%s [sudo hera.sh wakeup]\n" "$status"
            ;;
        *online*)
            printf "%s [sudo hera.sh poweroff]\n" "$status"
            ;;
        *)
            printf "unknown\n"
            ;;
    esac
    ;;
*)
    # if no parameters are given, print which are avaiable.
    printf "Usage: %s [wakeup|poweroff|status]" "$0"
    exit 1
    ;;
esac
