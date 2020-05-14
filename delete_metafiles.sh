#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/delete_metafiles.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:41:36+0200

output=$(mktemp /tmp/deleted_metafiles.XXXXXX)

[ ! "$(id -u)" = 0 ] \
   && printf "this script needs root privileges to run\n" \
   && exit 1

# files to delete
find /home \( \
    -name ".DS_Store" \
    -o -name "._*" \
    -o -name ".AppleDouble" \
    -o -name ".AppleDB" \
    -o -name ".@__thumb" \
    -o -name ".@__qini" \
    -o -name ":2e*" \
    \) > "$output"

# set output file permissions
chmod 755 "$output"

# delete files
while read -r f; do
    # printf "delete %s" ""$f"
    # rm -r "$f"
    trash-put "$f"
done < "$output"

# output result
$EDITOR "$output"
