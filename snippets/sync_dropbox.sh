#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/snippets/sync_dropbox.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 22:00:06

dbuser=klassiker
dbstatus=$(sudo -u $dbuser dropbox-cli status)

# start, sync and stop dropbox
if [ "$dbstatus" == "Dropbox isn't running!" ]; then
    dbstart=$(sudo -u $dbuser dropbox-cli start)
fi

count_done=1
while true; do
    status=$(sudo -u $dbuser dropbox-cli status)
    if [ "$dbstatus" == "Aktualisiert" ]; then
        count_done=$(expr $count_done + 1)
        if [ $count_done -gt 10 ]; then
            STOP=$(sudo -u $dbuser dropbox-cli stop && sudo -u $dbuser dropbox-cli autostart n)
            break
        fi
    fi
done
exit 0
