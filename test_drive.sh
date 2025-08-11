#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/test_drive.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-08-11T04:51:07+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

# rw_bytes (1M) * input_blocks (1024) = testfile (1gb)
rw_bytes=1M
input_blocks=1024
file_path="${1:-"$(pwd)"}/$(tr -cd 'a-f0-9' < /dev/urandom | head -c 16)"

# color variables
reset="\033[0m"
bold="\033[1m"
blue="\033[94m"
cyan="\033[96m"

# main
printf "%b%b  ->%b drop caches [Y]es/[n]o: " \
    "$bold" "$blue" "$reset" \
    && read -r drop_cache

printf "%b%b::%b %bwrite file (%s * %s)%b %b%s%b\n" \
    "$bold" "$blue" "$reset" "$bold" "$rw_bytes" "$input_blocks" "$reset" \
    "$cyan" "$file_path" "$reset"
dd if=/dev/zero of="$file_path" \
    bs="$rw_bytes" count="$input_blocks" conv=fdatasync,notrunc status=progress

case "${drop_cache:-"y"}" in
    y|Y|yes|Yes)
        $auth sh -c "printf 3 > /proc/sys/vm/drop_caches"
        ;;
esac

printf "%b%b::%b %bread file%b %b%s%b\n" \
    "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$file_path" "$reset"
dd if="$file_path" of=/dev/null \
    bs="$rw_bytes" count="$input_blocks" status=progress

printf "%b%b::%b %bdelete file%b %b%s%b\n" \
    "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$file_path" "$reset"
rm "$file_path"
