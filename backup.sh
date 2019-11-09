#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/backup.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-09 21:52:39

backupname="morpheus"
localhome="/home/klassiker"
remotelocation="alarm@prometheus:/home/alarm/backup/$backupname/"

# backup / to remote location (for testing rsync option --dry-run)
sudo rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","localhome/mount/*","$localhome/vm/*","/mnt/*","/media/*","/lost+found"} / $remotelocation
