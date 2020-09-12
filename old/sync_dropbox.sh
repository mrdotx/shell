#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/old/sync_dropbox.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-09-12T15:07:13+0200

dropbox_user=klassiker
dropbox_status=$(sudo -u $dropbox_user dropbox-cli status)

# start, sync and stop dropbox
if [ "$dropbox_status" = "Dropbox isn't running!" ]; then
    sudo -u $dropbox_user dropbox-cli start
fi

count_done=1
while true; do
    sudo -u $dropbox_user dropbox-cli status
    if [ "$dropbox_status" = "Aktualisiert" ]; then
        count_done=$(( count_done + 1 ))
        if [ $count_done -gt 10 ]; then
            sudo -u $dropbox_user dropbox-cli stop && sudo -u $dropbox_user dropbox-cli autostart n
            break
        fi
    fi
done
