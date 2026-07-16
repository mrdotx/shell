#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/archive/sync_dropbox.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:51:38+0200

# use standard C locale to avoid locale-specific issues and improve performance
export LC_ALL=C LANG=C

# config
dropbox_user=klassiker
dropbox_status=$(sudo -u $dropbox_user dropbox-cli status)

# start, sync and stop dropbox
if [ "$dropbox_status" = "Dropbox isn't running!" ]; then
    sudo -u $dropbox_user dropbox-cli start
fi

count_done=1
while true; do
    sudo -u $dropbox_user dropbox-cli status
    if [ "$dropbox_status" = "Updated" ]; then
        count_done=$(( count_done + 1 ))
        if [ $count_done -gt 10 ]; then
            sudo -u $dropbox_user dropbox-cli stop && sudo -u $dropbox_user dropbox-cli autostart n
            break
        fi
    fi
done
