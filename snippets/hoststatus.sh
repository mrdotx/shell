#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/snippets/hoststatus.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-09 22:14:21

# ping host and echo online or offline
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
