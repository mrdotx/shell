#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/newsboat.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-15 19:46:15

# reload feeds and compact the cache
ping -c1 -W1 -q google.com &> /dev/null && newsboat -x reload && newsboat -q -X &> /dev/null && notify-send "Newsboat" "Updated and adjusted!" --icon=messagebox_info || notify-send "Newsboat" "Problems update the feeds!" --icon=messagebox_warning
