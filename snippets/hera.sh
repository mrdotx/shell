#!/usr/bin/env bash

# path:       ~/projects/shell/snippets/hera.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-02-03T13:46:33+0100

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
        echo "$status [sudo $HOME/projects/shell/snippets/hera.sh wakeup]      "
    elif [[ $status == *online* ]]; then
        echo "$status [sudo $HOME/projects/shell/snippets/hera.sh poweroff]    "
    else
        echo "unknown"
    fi
    ;;
*)
    # if no parameters are given, print which are avaiable.
    echo "Usage: $0 {wakeup|poweroff|status}"
    exit 1
    ;;
esac
