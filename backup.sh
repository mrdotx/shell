#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/backup.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-11-05T14:03:30+0100

# auth can be something like sudo -A, doas -- or
# nothing, depending on configuration requirements
auth="doas"
backup_name="morpheus"
remote_location="alarm@prometheus:/home/alarm/backup/$backup_name/"

printf ":: create installed packages list\n"
paru -Qqe > "$XDG_CONFIG_HOME/paru/installed_packages.txt"
# to reinstall the packages: paru -S --needed - < "$XDG_CONFIG_HOME/paru/installed_packages.txt"

printf "\n:: backup / to remote location\n"
# for testing rsync option --dry-run
$auth rsync -aAXv --delete \
    --exclude="/dev/*" \
    --exclude="/lost+found" \
    --exclude="/mnt/*" \
    --exclude="/proc/*" \
    --exclude="/run/*" \
    --exclude="/srv/*" \
    --exclude="/sys/*" \
    --exclude="/tmp/*" / $remote_location
