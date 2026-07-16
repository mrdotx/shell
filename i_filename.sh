#!/bin/sh

# path:   /home/klassiker/Projects/repos/shell/i_filename.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-07-16T04:53:48+0200

# use standard C locale to avoid locale-specific issues and improve performance
export LC_ALL=C LANG=C

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
