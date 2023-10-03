#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup_keys.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-10-02T17:52:59+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
user_home="$HOME"

# config (rsync option --dry-run for testing)
rsync_options="-aAXvh --delete"
keys_label="/dev/disk/by-label/keys"
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

backup_keys_status() {
    dest="/mnt/$local_hostname"
    status_file="$dest/last_update"

    mkdir -p "$dest"
    printf "## backup %s\n\n" "$(date -I)" > "$status_file"
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
[ -h "$keys_label" ] \
    && mount_usb "$keys_label" \
    && backup_keys_status \
    && backup_keys_data "$user_home/.netrc" \
    && backup_keys_data "$user_home/.config/git" \
    && backup_keys_data "$user_home/.config/pam-gnupg" \
    && backup_keys_data "$user_home/.config/rclone" \
    && backup_keys_data "$user_home/.gnupg" \
    && backup_keys_data "$user_home/.ssh" \
    && backup_keys_data "$user_home/Cloud/webde/.keys" \
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

printf "please connect the following device to backup to:\n%s\n" \
    "$keys_label"
