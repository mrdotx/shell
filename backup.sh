#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/backup.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# config {{{
backupname="morpheus"
localhome="/home/klassiker"
remotelocation="alarm@prometheus:/home/alarm/backup/$backupname/"
# }}}

# backup / to remote location (for testing rsync option --dry-run) {{{
sudo rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","localhome/mount/*","$localhome/vm/*","/mnt/*","/media/*","/lost+found"} / $remotelocation
# }}}
