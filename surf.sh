#!/bin/sh

# path:       ~/projects/shell/surf.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-01 23:57:03

xidfile="/tmp/tabbed-surf.xid"
uri=""

if [ "$#" -gt 0 ];
then
    uri="$1"
fi

runtabbed() {
    tabbed -cdn tabbed-surf -r 2 surf -e '' "$uri" >"$xidfile" 2>/dev/null &
}

if [ ! -r "$xidfile" ];
then
    runtabbed
else
    xid=$(cat "$xidfile")
    if xprop -id "$xid" >/dev/null 2>&1;
    then
        surf -e "$xid" "$uri" >/dev/null 2>&1 &
    else
        runtabbed
    fi
fi
