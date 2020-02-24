#!/usr/bin/env bash

# path:       ~/projects/shell/snippets/hera.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-02-24T12:38:26+0100

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
    status="$("$HOME"/projects/shell/snippets/host_status.sh hera)"

    if [[ $status == *offline* ]]; then
        printf "%s [sudo %s/projects/shell/snippets/hera.sh wakeup]      " "$status" "$HOME"
    elif [[ $status == *online* ]]; then
        printf "%s [sudo %s/projects/shell/snippets/hera.sh poweroff]    " "$status" "$HOME"
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
