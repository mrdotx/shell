#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/i_filename.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-10-07T05:19:55+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# config
name="${1:-"filename-"}"
extension="${2:-".ext"}"
filename="${name}001$extension"

# main
while [ -e "$filename" ] || [ -h "$filename" ] ; do
    i=$((i + 1))
    filename=$(printf "%s%03d%s" "$name" "$i" "$extension")
done

printf "%s" "$filename"
