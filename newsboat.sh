#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/newsboat.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-17 11:51:14

# reload feeds and compact the cache
ping -c1 -W1 -q google.com &> /dev/null && newsboat -x reload && newsboat -q -X &> /dev/null && notify-send -i "$HOME/coding/shell/icons/rss.png" "Newsboat" "Updated and adjusted!" || notify-send "Newsboat" "Problems update the feeds!" --icon=messagebox_warning
