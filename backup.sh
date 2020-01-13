#!/bin/sh

# path:       ~/projects/shell/backup.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-13T12:14:06+0100

backup_name="morpheus"
remote_location="alarm@prometheus:/home/alarm/backup/$backup_name/"

# backup / to remote location (for testing rsync option --dry-run)
sudo rsync -aAXv --delete \
    --exclude="/dev/*" \
    --exclude="/home/klassiker/Downloads/*" \
    --exclude="/home/klassiker/VM/*" \
    --exclude="/lost+found" \
    --exclude="/media/*" \
    --exclude="/mnt/*" \
    --exclude="/proc/*" \
    --exclude="/run/*" \
    --exclude="/sys/*" \
    --exclude="/tmp/*" / $remote_location
