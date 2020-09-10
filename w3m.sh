#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/w3m.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/surf
# date:       2020-09-10T22:05:02+0200

script=$(basename "$0")
help="$script [-h/--help] -- wrapper script to start w3m
  Usage:
    $script [--tabbed]

  Settings:
    [--tabbed] = start w3m in suckless tabbed tool

  Examples:
    $script
    $script duckduckgo.com
    $script --tabbed duckduckgo.com"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    printf "%s\n" "$help"
elif [ "$1" = "--tabbed" ]; then
    options="$2"

    xidfile="/tmp/w3m/tabbed-w3m.xid"
    uri=""

    [ ! -d /tmp/w3m ] \
        && mkdir -p "/tmp/w3m"

    [ -n "$options" ] \
        && uri="$options"

    runtabbed() {
        tabbed -cdn tabbed-w3m -r 2 "$TERMINAL" -w '' -e w3m "$uri" >"$xidfile" 2>/dev/null &
    }

    if [ ! -r "$xidfile" ];
    then
        runtabbed
    else
        xid=$(cat "$xidfile")
        if xprop -id "$xid" >/dev/null 2>&1;
        then
            "$TERMINAL" -w "$xid" -e w3m "$uri" >/dev/null 2>&1 &
        else
            runtabbed
        fi
    fi
else
    $TERMINAL -e w3m "$@" &
fi
