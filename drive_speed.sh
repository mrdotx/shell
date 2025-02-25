#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/drive_speed.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-02-25T06:16:06+0100

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
printf "%b%b::%b %bWRITE%b file %b%s%b (%s * %s)\n" \
    "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$file_path" "$reset" \
    "$rw_bytes" "$input_blocks"
dd if=/dev/zero of="$file_path" \
    bs="$rw_bytes" count="$input_blocks" conv=fdatasync,notrunc status=progress

printf "\n%b%b::%b %bDROP%b caches\n" \
    "$bold" "$blue" "$reset" "$bold" "$reset"
$auth sh -c "printf 3 > /proc/sys/vm/drop_caches"

while [ "${i:=2}" -gt 0 ]; do
    i=$((i - 1))
    printf "%b%b::%b %bREAD%b file %b%s%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$file_path" "$reset"
    dd if="$file_path" of=/dev/null \
        bs="$rw_bytes" count="$input_blocks" status=progress
done

printf "\n%b%b::%b %bDELETE%b file %b%s%b\n" \
    "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$file_path" "$reset"
rm "$file_path"
