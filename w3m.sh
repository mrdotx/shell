#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/w3m.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-09-13T18:30:09+0200

script=$(basename "$0")
help="$script [-h/--help] -- wrapper script to start w3m
  Usage:
    $script [--readable/readable_window/--tabbed]

    without settings the url opens in new terminal window

  Settings:
    [--readable]        = make the html content radable with readability-cli
                          (Mozilla's Readability library)
    [--readable_window] = same as readable in new window
    [--tabbed]          = start w3m in suckless tabbed tool

  Examples:
    $script
    $script suckless.org
    $script --readable suckless.org
    $script --readable_window suckless.org
    $script --tabbed suckless.org"

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    --readable)
        readable "$2" | w3m -T text/html
        ;;
    --readable_window)
        readable "$2" > "/tmp/readable.html"
        $TERMINAL -e w3m "/tmp/readable.html" &
        ;;
    --tabbed)
        xidfile="/tmp/w3m/tabbed-w3m.xid"
        uri=""

        [ ! -d /tmp/w3m ] \
            && mkdir -p "/tmp/w3m"

        [ -n "$2" ] \
            && uri="$2"

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
        ;;
    *)
        $TERMINAL -e w3m "$@" &
        ;;
esac
