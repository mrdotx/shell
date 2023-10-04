#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/backup_keys.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-10-04T08:50:23+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
user_home="$HOME"

# config (rsync option --dry-run for testing)
rsync_options="-aAXvh --delete"

# helper functions
backup_data() {
    printf "==> backup %s to %s\n\n" "$1" "$mnt"
    eval "rsync $rsync_options $1 $mnt"
    printf "\n"
}

backup_pgp() {
    printf "==> backup pgp to %s\n\n" "$1"
    mkdir -p "$1"
    gpg --export --export-options backup --output "$1/public.gpg"
    gpg --export-secret-keys --export-options backup --output "$1/private.gpg"
    gpg --export-ownertrust > "$1/ownertrust.gpg"
}

backup() {
    for label in "$@"; do
        unset mnt

        # mount
        [ -h "/dev/disk/by-label/$label" ] \
            && mnt="/mnt/$label" \
            && printf ":: create and mount backup folder %s\n" "$mnt" \
            && $auth mkdir -p "$mnt" \
            && $auth mount "/dev/disk/by-label/$label" "$mnt"

        # backup
        [ -d "$mnt" ] \
            && status_file="$mnt/last_update" \
            && printf "## backup %s\n\n" "$(date -I)" > "$status_file" \
            && backup_data "$user_home/.netrc" >> "$status_file" \
            && backup_data "$user_home/.config/git" >> "$status_file" \
            && backup_data "$user_home/.config/pam-gnupg" >> "$status_file" \
            && backup_data "$user_home/.config/rclone" >> "$status_file" \
            && backup_data "$user_home/.gnupg" >> "$status_file" \
            && backup_data "$user_home/.ssh" >> "$status_file" \
            && backup_data "$user_home/Cloud/webde/.keys" >> "$status_file" \
            && backup_data "$user_home/.local/share/repos/password-store" >> "$status_file" \
            && printf "  -> backup pgp [y]es/[N]o: " \
                && read -r pgp_backup \
                && case "$pgp_backup" in
                    y|Y|yes|Yes)
                        backup_pgp "$mnt/pgp" >> "$status_file"
                        ;;
                esac \
            && $PAGER "$status_file"

        # unmount
        [ -d "$mnt" ] \
            && printf ":: unmount and delete backup folder %s\n" "$mnt" \
            && $auth umount "$mnt" \
            && $auth find "$mnt" -empty -type d -delete \
            && return 0
    done
}

# main
backup keys \
    && exit 0

printf ":: please connect the following device to backup to:\n  -> %s\n" \
    "$label"
