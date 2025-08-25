#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/w3m.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-08-25T05:50:42+0200

# WORKAROUND: change directory to set the download folder
cd "$HOME/Downloads" || exit

# help
script=$(basename "$0")
help="$script [-h/--help] -- wrapper script to start w3m
  Usage:
    $script [--tabbed]

  Settings:
    [--tabbed] = start w3m in suckless tabbed tool

  Examples:
    $script
    $script suckless.org
    $script --tabbed w3m.sourceforge.net suckless.org "

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    --tabbed)
        shift
        xidfile="/tmp/w3m/tabbed-w3m.xid"
        mkdir -p "/tmp/w3m"

        for uri in "${@:-"$WWW_HOME"}"; do
            xid=$(cat "$xidfile" 2>/dev/null)
            case $? in
                0)
                    if xprop -id "$xid" >/dev/null 2>&1; then
                        st -w "$xid" -e w3m "$uri" >/dev/null 2>&1 &
                    else
                        tabbed -cdn tabbed-w3m -r 2 \
                            st -w '' -e w3m "$uri" >/dev/null 2>&1 &
                    fi
                    ;;
                *)
                    tabbed -cdn tabbed-w3m -r 2 \
                        st -w '' -e w3m "$uri" >"$xidfile" 2>/dev/null &
                    ;;
            esac
            sleep 1
        done
        ;;
    *)
        if [ -z "$TMUX" ]; then
            $TERMINAL -e w3m "$@" &
        else
            w3m "$@"
        fi
        ;;
esac
