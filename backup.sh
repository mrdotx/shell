#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2022-02-23T17:10:47+0100

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="$EXEC_AS_USER"
backup_name=$(hostname)
remote_location="pi2:/home/alarm/backup/$backup_name/"

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
