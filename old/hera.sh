#!/usr/bin/env bash

# path:       /home/klassiker/.local/share/repos/shell/old/hera.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:17:23+0200

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
    # call hoststatus script
    status="$("$HOME"/repos/shell/snippets/host_status.sh hera)"

    if [[ $status == *offline* ]]; then
        printf "%s [sudo %s/repos/shell/snippets/hera.sh wakeup]      " "$status" "$HOME"
    elif [[ $status == *online* ]]; then
        printf "%s [sudo %s/repos/shell/snippets/hera.sh poweroff]    " "$status" "$HOME"
    else
        printf "unknown\n"
    fi
    ;;
*)
    # if no parameters are given, print which are avaiable.
    printf "Usage: %s {wakeup|poweroff|status}" "$0"
    exit 1
    ;;
esac
