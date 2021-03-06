#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-06-04T19:46:20+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="$EXEC_AS_USER"
backup_name=$(hostname)
remote_location="alarm@prometheus:/home/alarm/backup/$backup_name/"

printf "\n:: backup / to remote location\n"
# for testing rsync option --dry-run
$auth rsync -aAXvh --delete \
    --exclude="/dev/*" \
    --exclude="/lost+found" \
    --exclude="/mnt/*" \
    --exclude="/proc/*" \
    --exclude="/run/*" \
    --exclude="/srv/*" \
    --exclude="/sys/*" \
    --exclude="/tmp/*" / "$remote_location"
