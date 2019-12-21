#!/bin/sh

# path:       ~/projects/shell/polybar_rss.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 17:05:12

# exit if newsboat is running
pgrep -x newsboat > /dev/null 2>&1 && polybar-msg hook module/rss 2 > /dev/null 2>&1 && exit

if ping -c1 -W1 -q 1.1.1.1 > /dev/null 2>&1; then
    newsboat -x reload && newsboat -q -X > /dev/null 2>&1 && polybar-msg hook module/rss 3 > /dev/null 2>&1
else
    polybar-msg hook module/rss 3 > /dev/null 2>&1
fi
