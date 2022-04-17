#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/w3m.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-04-17T18:42:53+0200

script=$(basename "$0")
help="$script [-h/--help] -- wrapper script to start w3m
  Usage:
    $script [--tabbed]

  Settings:
    [--tabbed] = start w3m in suckless tabbed tool

  Examples:
    $script
    $script suckless.org
    $script --tabbed suckless.org"

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    --tabbed)
        xidfile="/tmp/w3m/tabbed-w3m.xid"

        [ -n "$2" ] \
            && uri="$2"

        mkdir -p "/tmp/w3m"

        runtabbed() {
            tabbed -cdn tabbed-w3m \
                -r 2 "$TERMINAL" \
                -w '' \
                -e w3m "$uri" >"$xidfile" 2>/dev/null &
        }

        if [ ! -r "$xidfile" ]; then
            runtabbed
        else
            xid=$(cat "$xidfile")
            if xprop -id "$xid" >/dev/null 2>&1; then
                "$TERMINAL" -w "$xid" -e w3m "$uri" >/dev/null 2>&1 &
            else
                runtabbed
            fi
        fi
        ;;
    *)
        if [ -z "$TMUX" ]; then
            $TERMINAL -e w3m "$@" &
        else
            w3m "$@"
        fi
        ;;
esac
