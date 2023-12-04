#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/aria2c.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-12-02T18:52:48+0100

# config
links_file="$HOME/Public/downloads/links.txt"

# help
script=$(basename "$0")
help="$script [-h/--help] -- wrapper script to download with aria2c
  Usage:
    $script [-a/--add] <url>

  Settings:
    without given settings, continue downloading from links file
    [-a/--add] = add url to links file (don't restart aria2c)
    <url>      = file download link

  Examples:
    $script
    $script \"http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz\"
    $script -a \"http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz\"

  Config:
    links file = $links_file"

aria2c_stop() {
    pid=$(pgrep -x aria2c$)
    [ -n "$pid" ] \
        && kill "$pid" \
        && while pgrep -x aria2c >/dev/null; do
                sleep .1
            done
}

aria2c_start() {
    aria2c \
        --input-file="$links_file" \
        --save-session="$links_file"
}

add_url() {
    [ -s "$links_file" ] \
        && links=$(grep -v " gid=" "$links_file") \
        && printf "%s\n%s\n" "$links" "$1" \
            | tr -d '[:blank:]' \
            | sort -u > "$links_file" \
        && return 0

    printf "%s\n" "$1" \
        | tr -d '[:blank:]' > "$links_file"
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -a | --add)
        [ -n "$2" ] \
            && add_url "$2"
        ;;
    *)
        aria2c_stop
        [ -n "$1" ] \
            && add_url "$1"
        aria2c_start
        ;;
esac
