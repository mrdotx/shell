#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/old/hera.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-05-28T21:45:26+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

case "$1" in
wakeup)
    # send magic paket to hera
    wakeonlan 00:08:9b:c6:99:76
    ;;
poweroff)
    # send poweroff commands per ssh
    ssh -t admin@hera "/sbin/poweroff"
    ;;
status)
    # call host status script
    status="$("$HOME"/.local/share/repos/shell/old/host_status.sh hera)"

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
    printf "Usage: %s {wakeup|poweroff|status}" "$0"
    exit 1
    ;;
esac
