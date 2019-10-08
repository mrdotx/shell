#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/hoststatus.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# procedure {{{
exec="ping -c 1"

function color() {
    echo "\e[$1m$2\e[0m"
}
online=$(color 32 "online ")
offline=$(color 31 "offline")

function ping_remote() {
    ping -c 1 $1 -w 1 >>/dev/null
    if [ $? == 0 ]; then
        echo -e "$online"
    else
        echo -e "$offline"
    fi
}
run_function=$(ping_remote $1)
echo "$run_function"
# }}}
