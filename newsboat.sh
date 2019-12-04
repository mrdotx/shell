#!/bin/sh

# path:       ~/coding/shell/newsboat.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-04 14:01:31

# exit if newsboat is running
pgrep -x newsboat && exit

# reload feeds and compact the cache
if ping -c1 -W1 -q 1.1.1.1 > /dev/null 2>&1; then
    newsboat -x reload && newsboat -q -X > /dev/null 2>&1 && \
        notify-send -i "$HOME/coding/shell/icons/rss.png" "Newsboat" "Cache updated and shrinked!"
        notify-send -i "$HOME/coding/shell/icons/rss.png" "Newsboat" "$(newsboat -x print-unread)"
else
    notify-send -i "$HOME/coding/shell/icons/caution.png" "Newsboat" "Update feeds not possible!"
fi
