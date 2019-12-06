#!/bin/sh

# path:       ~/coding/shell/sync_keepass.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-06 18:39:06

rc_name="dropbox"
kp_file="klassiker.kdbx"
kp_local="$HOME/cloud/dropbox/KeePass/"
kp_remote="/KeePass"

# assemble full path to local and remote files
kp_local_path="$kp_local/$kp_file"
kp_remote_path="$kp_remote/$kp_file"

# import and export commands
pass_exp="rclone copy $kp_local_path $rc_name:$kp_remote"
pass_imp="rclone copy $rc_name:$kp_remote_path $kp_local"

# get datetime from string
get_dt_from_str ()
{
    date -d "$1" +"%F %T.%3N"
}

# parse local passwords file modification time
get_local_pass_mtime ()
{
    string=$(stat -c %y "$kp_local_path" | cut -d ' ' -f 1,2;)
    get_dt_from_str "$string"
}

# parse remote passwords file modification time
get_remote_pass_mtime ()
{
    output=$(rclone lsl $rc_name:$kp_remote_path 2>/dev/null)
    if [ $? -eq 3 ]; then
        unset output
        return 1
    else
        string=$(echo "$output" | tr -s ' ' | cut -d ' ' -f 3,4;)
        get_dt_from_str "$string"
        unset output
        return 0
    fi
}

sync_pass ()
{
    # storing the values
    local_mtime=$(get_local_pass_mtime)
    remote_mtime=$(get_remote_pass_mtime)

    # modification times
    notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass [Files]" "local:  $local_mtime\nremote: $remote_mtime"

    # if remote file don't exists
    if [ -z "$remote_mtime" ]; then
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass [Files]" "remote file not found!\nuploading...!"
        $pass_exp
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass [Database]" "created!"
        return 0
    fi

    # conversion required for comparison
    local_mtime_sec=$(date -d "$local_mtime" +%s)
    remote_mtime_sec=$(date -d "$remote_mtime" +%s)

    # local file - 10 sec being newer than remote
    if [ $((local_mtime_sec-10)) -gt "$remote_mtime_sec" ]; then
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass [Files]" "local file is probably newer than remote!\nuploading...!"
        $pass_exp
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass [Database]" "synchronized!"
        return 0
    # local file +10 sec being older than remote
    elif [ $((local_mtime_sec+10)) -lt "$remote_mtime_sec" ]; then
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass [Files]" "local file is probably older than remote!\ndownloading...!"
        $pass_imp
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass [Database]" "synchronized!"
        return 0
    else
        notify-send -i "$HOME/coding/shell/icons/keepass.png" "KeePass [Database]" "allready synchronized!"
        return 0
    fi
}

# check internet connection
if ping -c1 -W1 -q 1.1.1.1 > /dev/null 2>&1; then
    sync_pass
else
    notify-send -i "$HOME/coding/shell/icons/caution.png" "KeePass [Failure]" "internet connection not available!"
fi
