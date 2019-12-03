#!/bin/sh

# path:       ~/coding/shell/backup.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-03 07:23:43

backup_name="morpheus"
local_home="/home/klassiker"
remote_location="alarm@prometheus:/home/alarm/backup/$backup_name/"

# backup / to remote location (for testing rsync option --dry-run)
sudo rsync -aAXv --delete \
    --exclude="/dev/*" \
    --exclude="/proc/*" \
    --exclude="/sys/*" \
    --exclude="/tmp/*" \
    --exclude="/run/*" \
    --exclude="$local_home/mount/*" \
    --exclude="$local_home/VM/*" \
    --exclude="/mnt/*" \
    --exclude="/media/*" \
    --exclude="/lost+found" \
    --exclude="/swapfile" / $remote_location
