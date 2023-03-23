#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-03-23T10:04:05+0100

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

# config (rsync option --dry-run for testing)
rsync_options="-aAXvh --delete \
        --exclude='/home/klassiker/Desktop' \
        --exclude='/home/klassiker/Downloads' \
        --exclude='/home/klassiker/Music' \
        --exclude='/home/klassiker/Public' \
        --exclude='/home/klassiker/Templates' \
        --exclude='/home/klassiker/Videos' \
        --exclude='/dev' \
        --exclude='/lost+found' \
        --exclude='/mnt' \
        --exclude='/proc' \
        --exclude='/run' \
        --exclude='/sys' \
        --exclude='/tmp'"
backup_partlabel="/dev/disk/by-partlabel/backup"
keys_partlabel="/dev/disk/by-partlabel/keys"
local_hostname="$(hostname)"

# helper functions
mount_usb() {
    mount_point="/mnt/$local_hostname"

    printf ":: create and mount backup folder %s\n" "$mount_point"
    $auth mkdir -p "$mount_point"
    $auth mount "$1" "$mount_point"
}

unmount_usb() {
    mount_point="/mnt/$local_hostname"

    printf "\n:: unmount and delete folder %s\n" "$mount_point"
    $auth umount "$mount_point"
    $auth find "$mount_point" -empty -type d -delete
}

backup_local() {
    remote="/mnt/$local_hostname/hosts/$local_hostname"

    printf "\n:: create folder and backup / to %s\n" "$remote"
    $auth mkdir -p "$remote"
    eval "$auth rsync $rsync_options / $remote"
}

backup_remote() {
    local="/mnt/$local_hostname/hosts/$1"

    # set remote location and rsync options by hostname
    case "$1" in
        m625q)
            remote="$1:/"
            options="$rsync_options \
                --exclude='/srv/http/download' \
                --rsync-path='$auth rsync'"
            ;;
        mi)
            remote="$1:/"
            options="$rsync_options \
                --rsync-path='$auth rsync'"
            ;;
    esac

    printf "\n:: create folder and backup %s to %s\n" "$remote" "$local"
    $auth mkdir -p "$local"
    ssh -q "$1" exit
    case $? in
        0)
            eval "$auth rsync $options $remote $local"
            ;;
        *)
            printf "connect to %s failed, please check if ssh is enabled!\n" \
                "$1"
            ;;
    esac
}

backup_keys_status() {
    keys_folder="/mnt/$local_hostname/keys"
    keys_status_file="$keys_folder/last_update"

    mkdir -p "$keys_folder"
    date '+%d.%m.%Y %H:%M:%S' > "$keys_status_file"
    printf "###################\n\n" >> "$keys_status_file"
}

backup_keys_folder() {
    printf "==> backup %s to %s\n\n" "$1" "$keys_folder"
    rsync -aAXvh --delete  "$1" "$keys_folder"
    printf "\n"
} >> "$keys_status_file"

backup_keys_pgp() {
    printf "==> backup pgp to %s\n\n" "$1"
    mkdir -p "$1"
    gpg --armor --export > "$1"/pgp-public-keys.asc
    gpg --armor --export-secret-keys > "$1"/pgp-private-keys.asc
    gpg --export-ownertrust > "$1"/pgp-ownertrust.asc
} >> "$keys_status_file"

# main
[ -h "$backup_partlabel" ] \
    && mount_usb "$backup_partlabel" \
    && backup_local \
    && backup_remote "m625q" \
    && backup_remote "mi" \
    && unmount_usb \
    && exit 0

[ -h "$keys_partlabel" ] \
    && mount_usb "$keys_partlabel" \
    && backup_keys_status \
    && backup_keys_folder "$HOME/.netrc" \
    && backup_keys_folder "$HOME/.config/git" \
    && backup_keys_folder "$HOME/.config/pam-gnupg" \
    && backup_keys_folder "$HOME/.gnupg" \
    && backup_keys_folder "$HOME/.ssh" \
    && backup_keys_folder "$HOME/.local/cloud/webde/.keys" \
    && backup_keys_folder "$HOME/.local/share/repos/password-store" \
    && printf "  -> backup pgp [y]es/[N]o: " \
        && read -r backup_pgp \
    && case "$backup_pgp" in
        y|Y|yes|Yes)
            backup_keys_pgp "$keys_folder/.pgp"
            ;;
    esac \
    && unmount_usb \
    && exit 0

printf "please connect one of the following devices to backup to:\n%s\n%s\n" \
    "$keys_partlabel" \
    "$backup_partlabel"
