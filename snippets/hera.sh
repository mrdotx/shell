#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/snippets/hera.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# procedure {{{
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
    status="$($HOME/coding/shell/snippets/hoststatus.sh hera)"

    if [[ $status == *offline* ]]; then
        echo "$status [sudo $HOME/coding/shell/snippets/hera.sh wakeup]      "
    elif [[ $status == *online* ]]; then
        echo "$status [sudo $HOME/coding/shell/snippets/hera.sh poweroff]    "
    else
        echo "unknown"
    fi
    ;;
*)
    # If no parameters are given, print which are avaiable.
    echo "Usage: $0 {wakeup|poweroff|status}"
    exit 1
    ;;
esac
# }}}
