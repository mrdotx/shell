#!/bin/sh

# path:       ~/coding/shell/polybar_rss.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-12 23:23:05

# exit if newsboat is running
pgrep -x newsboat && exit

# reload feeds and compact the cache
if ping -c1 -W1 -q 1.1.1.1 > /dev/null 2>&1; then
    polybar-msg hook module/rss 2
else
    polybar-msg hook module/rss 1
fi
