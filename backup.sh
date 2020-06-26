#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/backup.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-06-26T16:54:47+0200

# auth can be something like sudo -A, doas -- or
# nothing, depending on configuration requirements
auth="doas --"
backup_name="morpheus"
remote_location="alarm@prometheus:/home/alarm/backup/$backup_name/"

printf ":: create installed packages list\n"
yay -Qqe > "$XDG_CONFIG_HOME/yay/installed_packages.txt"
# to reinstall the packages: yay -S --needed - < "$XDG_CONFIG_HOME/yay/installed_packages.txt"

printf "\n:: backup / to remote location\n"
# for testing rsync option --dry-run
$auth rsync -aAXv --delete \
    --exclude="/dev/*" \
    --exclude="/vms/*" \
    --exclude="/lost+found" \
    --exclude="/mnt/*" \
    --exclude="/proc/*" \
    --exclude="/run/*" \
    --exclude="/sys/*" \
    --exclude="/tmp/*" / $remote_location
