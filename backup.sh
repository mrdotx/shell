#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-05-02T21:53:15+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
user_home="$HOME"

# config (rsync option --dry-run for testing)
rsync_options="-aAXvh --delete \
        --exclude='$user_home/Desktop' \
        --exclude='$user_home/Downloads' \
        --exclude='$user_home/Music' \
        --exclude='$user_home/Public' \
        --exclude='$user_home/Templates' \
        --exclude='$user_home/Videos' \
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
    mnt="/mnt/$local_hostname"

    printf ":: create and mount backup folder %s\n" "$mnt"
    $auth mkdir -p "$mnt"
    $auth mount "$1" "$mnt"
}

unmount_usb() {
    mnt="/mnt/$local_hostname"

    printf "\n:: unmount and delete backup folder %s\n" "$mnt"
    $auth umount "$mnt"
    $auth find "$mnt" -empty -type d -delete
}

backup_local() {
    dest="/mnt/$local_hostname/hosts/$local_hostname"

    printf "\n:: create folder and backup / to %s\n" "$dest"
    $auth mkdir -p "$dest"
    eval "$auth rsync $rsync_options / $dest"
}

backup_remote() {
    dest="/mnt/$local_hostname/hosts/$1"

    # set remote location and rsync options by hostname
    case "$1" in
        m625q)
            src="$1:/"
            options="$rsync_options \
                --exclude='/srv/http/download' \
                --exclude='/srv/http/pacman' \
                --rsync-path='$auth rsync'"
            ;;
        mi)
            src="$1:/"
            options="$rsync_options \
                --rsync-path='$auth rsync'"
            ;;
    esac

    printf "\n:: create folder and backup %s to %s\n" "$src" "$dest"
    $auth mkdir -p "$dest"
    ssh -q "$1" exit
    case $? in
        0)
            eval "$auth rsync $options $src $dest"
            ;;
        *)
            printf "connect to %s failed, please check if ssh is enabled!\n" \
                "$1"
            ;;
    esac
}

backup_keys_status() {
    dest="/mnt/$local_hostname"
    status_file="$dest/last_update"

    mkdir -p "$dest"
    date '+%d.%m.%Y %H:%M:%S' > "$status_file"
    printf "###################\n\n" >> "$status_file"
}

backup_keys_data() {
    printf "==> backup %s to %s\n\n" "$1" "$dest"
    eval "rsync $rsync_options $1 $dest"
    printf "\n"
} >> "$status_file"

backup_keys_pgp() {
    printf "==> backup pgp to %s\n\n" "$1"
    mkdir -p "$1"
    gpg --export --export-options backup --output "$1/public.gpg"
    gpg --export-secret-keys --export-options backup --output "$1/private.gpg"
    gpg --export-ownertrust > "$1/ownertrust.gpg"
} >> "$status_file"

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
    && backup_keys_data "$user_home/.netrc" \
    && backup_keys_data "$user_home/.config/git" \
    && backup_keys_data "$user_home/.config/pam-gnupg" \
    && backup_keys_data "$user_home/.gnupg" \
    && backup_keys_data "$user_home/.ssh" \
    && backup_keys_data "$user_home/.local/cloud/webde/.keys" \
    && backup_keys_data "$user_home/Documents/Software/gpg-backup.md" \
    && backup_keys_data "$user_home/.local/share/repos/password-store" \
    && printf "  -> backup pgp [y]es/[N]o: " \
        && read -r backup_pgp \
    && case "$backup_pgp" in
        y|Y|yes|Yes)
            backup_keys_pgp "$dest/pgp"
            ;;
    esac \
    && $PAGER "$status_file" \
    && unmount_usb \
    && exit 0

printf "please connect one of the following devices to backup to:\n%s\n%s\n" \
    "$keys_partlabel" \
    "$backup_partlabel"
