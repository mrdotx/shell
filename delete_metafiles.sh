#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/delete_metafiles.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-01-01T11:34:20+0100

[ ! "$(id -u)" = 0 ] \
    && printf "this script needs root privileges to run\n" \
    && exit 1

# default search in the current folder
folder="${1:-.}"
output=$(mktemp -t delete_metafiles.XXXXXX)

# files to delete
find "$folder" \( \
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

# delete tmp file
rm -f "$output"
