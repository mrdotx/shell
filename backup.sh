#!/bin/bash

# path:       ~/coding/shell/backup.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 11:46:00

backupname="morpheus"
localhome="/home/klassiker"
remotelocation="alarm@prometheus:/home/alarm/backup/$backupname/"

# backup / to remote location (for testing rsync option --dry-run)
sudo rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","$localhome/mount/*","$localhome/VM/*","/mnt/*","/media/*","/lost+found","/swapfile"} / $remotelocation
