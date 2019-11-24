#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/newsboat.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-25 00:47:40

# exit if newsboat is running
pgrep -x newsboat && exit

# reload feeds and compact the cache
ping -c1 -W1 -q 1.1.1.1 &> /dev/null && \
    newsboat -x reload && newsboat -q -X &> /dev/null && \
    notify-send -i "$HOME/coding/shell/icons/rss.png" "Newsboat" "Updated and shrinked the cache!" || \
    notify-send -i "$HOME/coding/shell/icons/caution.png" "Newsboat" "Problem with update the feeds!"
