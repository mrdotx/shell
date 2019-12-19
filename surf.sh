#!/bin/sh

# path:       ~/coding/shell/surf.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-19 12:29:34

xidfile="/tmp/tabbed-surf.xid"
uri=""

if [ "$#" -gt 0 ];
then
	uri="$1"
fi

runtabbed() {
	tabbed -dn tabbed-surf -r 2 surf -e '' "$uri" >"$xidfile" \
		2>/dev/null &
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
