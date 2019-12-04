#!/usr/bin/env bash

# path:       ~/coding/shell/snippets/hera.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-04 16:11:19

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
    status="$("$HOME"/coding/shell/snippets/host_status.sh hera)"

    if [[ $status == *offline* ]]; then
        echo "$status [sudo $HOME/coding/shell/snippets/hera.sh wakeup]      "
    elif [[ $status == *online* ]]; then
        echo "$status [sudo $HOME/coding/shell/snippets/hera.sh poweroff]    "
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
