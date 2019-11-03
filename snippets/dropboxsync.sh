#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/snippets/dropboxsync.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:29:11

# variables {{{
DBUSER=klassiker
STATUS=$(sudo -u $DBUSER dropbox-cli status)
# }}}

# procedure {{{
if [ "$STATUS" == "Dropbox isn't running!" ]; then
    START=$(sudo -u $DBUSER dropbox-cli start)
fi

COUNT_DONE=1
while true; do
    STATUS=$(sudo -u $DBUSER dropbox-cli status)
    if [ "$STATUS" == "Aktualisiert" ]; then
        COUNT_DONE=$(expr $COUNT_DONE + 1)
        if [ $COUNT_DONE -gt 10 ]; then
            STOP=$(sudo -u $DBUSER dropbox-cli stop && sudo -u $DBUSER dropbox-cli autostart n)
            break
        fi
    fi
done
exit 0
# }}}
