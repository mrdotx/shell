#!/bin/sh

# path:       ~/coding/shell/polybar_rss.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-13 13:55:48

# exit if newsboat is running
pgrep -x newsboat > /dev/null 2>&1 && polybar-msg hook module/rss 1 > /dev/null 2>&1 && exit

if ping -c1 -W1 -q 1.1.1.1 > /dev/null 2>&1; then
    newsboat -x reload && newsboat -q -X > /dev/null 2>&1 && polybar-msg hook module/rss 2 > /dev/null 2>&1
else
    polybar-msg hook module/rss 2 > /dev/null 2>&1
fi
