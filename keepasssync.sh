#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/keepasssync.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-21 01:13:05

drive_name="gmx"
db_file_name="klassiker.kdbx"
local_location="$HOME/Dokumente/KeePass/"
remote_location="/Docs/KeePass"

# assemble full path to local and remote files
local_path="$local_location/$db_file_name"
remote_path="$remote_location/$db_file_name"

# alias import and export commands
alias passwords_export="rclone copy $local_path $drive_name:$remote_location"
alias passwords_import="rclone copy $drive_name:$remote_path $local_location"
shopt -s expand_aliases

function format_datetime_from_string ()
{
    echo `date -d "$1" +"%F %T.%3N"`
}

# parse local passwords file modification time
function get_local_passwords_mtime ()
{
    local string=`stat -c %y $local_path | cut -d ' ' -f 1,2;`
    echo `format_datetime_from_string "$string"`
}

# parse remote passwords file modification time
function get_remote_passwords_mtime ()
{
    output=`rclone lsl $drive_name:$remote_path 2>/dev/null`
    if [ $? -eq 3 ]; then
        unset output
        return 1
    else
        local string=`echo "$output" | tr -s ' ' | cut -d ' ' -f 3,4;`
        echo `format_datetime_from_string "$string"`
        unset output
        return 0
    fi
}

function sync_passwords ()
{
    # storing the values
    local human_readable_local_mtime=`get_local_passwords_mtime`
    human_readable_remote_mtime=`get_remote_passwords_mtime 2>/dev/null`

    # if remote file don't exists
    if [ $? -ne 0 ]; then
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "No remote passwords file found!\nExporting...!"
        passwords_export
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Database synchronized!"
        return 0
    fi

    # modification times
    notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "File time Local/Remote:\n$human_readable_local_mtime\n$human_readable_remote_mtime"

    # conversion required for comparison
    local_mtime_in_seconds_since_epoch=$(date -d "$human_readable_local_mtime" +%s)
    remote_mtime_in_seconds_since_epoch=$(date -d "$human_readable_remote_mtime" +%s)
    unset human_readable_remote_mtime

    # local being newer than remote
    if [ "$local_mtime_in_seconds_since_epoch" -gt "$remote_mtime_in_seconds_since_epoch" ]; then
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Local passwords file is probably newer than remote!\nExporting...!"
        passwords_export
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Database synchronized!"
    return 0

    # remote being newer than local
    elif [ "$local_mtime_in_seconds_since_epoch" -lt "$remote_mtime_in_seconds_since_epoch" ]; then
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Local passwords file is probably older than remote!\nImporting...!"
        passwords_import
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Database synchronized!"
    return 0

    else
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass" "Database allready synchronized!"
    return 0
    fi
}

# check internet connection
ping -c1 -W1 -q google.com &> /dev/null && sync_passwords || \
    notify-send -i "$HOME/coding/shell/icons/caution.png" "KeePass" "Problem with database synchronisation!"
