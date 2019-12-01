#!/bin/sh

# path:       ~/coding/shell/snippets/sync_dropbox.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 17:09:53

dbuser=klassiker
dbstatus=$(sudo -u $dbuser dropbox-cli status)

# start, sync and stop dropbox
if [ "$dbstatus" = "Dropbox isn't running!" ]; then
    sudo -u $dbuser dropbox-cli start
fi

count_done=1
while true; do
    sudo -u $dbuser dropbox-cli status
    if [ "$dbstatus" = "Aktualisiert" ]; then
        count_done=$(( count_done + 1 ))
        if [ $count_done -gt 10 ]; then
            sudo -u $dbuser dropbox-cli stop && sudo -u $dbuser dropbox-cli autostart n
            break
        fi
    fi
done
exit 0
