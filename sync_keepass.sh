#!/bin/sh

# path:       ~/coding/shell/sync_keepass.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 20:19:55

drive_name="gmx"
db_file_name="klassiker.kdbx"
local_location="$HOME/Dokumente/KeePass/"
remote_location="/Docs/KeePass"

# assemble full path to local and remote files
local_path="$local_location/$db_file_name"
remote_path="$remote_location/$db_file_name"

# import and export commands
passwords_export="rclone copy $local_path $drive_name:$remote_location"
passwords_import="rclone copy $drive_name:$remote_path $local_location"

format_datetime_from_string ()
{
    date -d "$1" +"%F %T.%3N"
}

# parse local passwords file modification time
get_local_passwords_mtime ()
{
    string=$(stat -c %y "$local_path" | cut -d ' ' -f 1,2;)
    format_datetime_from_string "$string"
}

# parse remote passwords file modification time
get_remote_passwords_mtime ()
{
    output=$(rclone lsl $drive_name:$remote_path 2>/dev/null)
    if [ $? -eq 3 ]; then
        unset output
        return 1
    else
        string=$(echo "$output" | tr -s ' ' | cut -d ' ' -f 3,4;)
        format_datetime_from_string "$string"
        unset output
        return 0
    fi
}

sync_passwords ()
{
    # storing the values
    human_readable_local_mtime=$(get_local_passwords_mtime)
    human_readable_remote_mtime=$(get_remote_passwords_mtime 2>/dev/null)

    # if remote file don't exists
    if ! get_remote_passwords_mtime > /dev/null 2>&1; then
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "No remote passwords file found!\nExporting...!"
        $passwords_export
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Database created!"
        return 0
    fi

    # modification times
    notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "File time Local/Remote:\n$human_readable_local_mtime\n$human_readable_remote_mtime"

    # conversion required for comparison
    local_mtime_in_seconds_since_epoch=$(date -d "$human_readable_local_mtime" +%s)
    remote_mtime_in_seconds_since_epoch=$(date -d "$human_readable_remote_mtime" +%s)

    # local being newer than remote
    if [ "$local_mtime_in_seconds_since_epoch" -gt "$remote_mtime_in_seconds_since_epoch" ]; then
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Local passwords file is probably newer than remote!\nExporting...!"
        $passwords_export
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Database synchronized!"
        return 0

    # remote being newer than local
    elif [ "$local_mtime_in_seconds_since_epoch" -lt "$remote_mtime_in_seconds_since_epoch" ]; then
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Local passwords file is probably older than remote!\nImporting...!"
        $passwords_import
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Database synchronized!"
        return 0

    else
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Database allready synchronized!"
        return 0
    fi
}

# check internet connection
if ping -c1 -W1 -q 1.1.1.1 > /dev/null 2>&1; then
    sync_passwords
else
    notify-send -i "$HOME/coding/shell/icons/caution.png" "KeePass" "Problem with database synchronisation!"
fi
