#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/aria2c.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-11-07T21:42:24+0100

# config
links_file="$HOME/.config/aria2/aria2-download-links"

script=$(basename "$0")
help="$script [-h/--help] -- wrapper script to download with aria2c
  Usage:
    $script <url>

  Settings:
    without given settings, continue downloading from links file
    <url> = url to download

  Examples:
    $script
    $script \"http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz\"

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
        -i "$links_file" \
        --save-session="$links_file"
}

add_url() {
    cleaned_list="$(grep -v " gid=" "$2")"
    printf "%s\n%s\n" "$cleaned_list" "$1" \
        | tr -d '[:blank:]' \
        | sort -u > "$links_file"
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    *)
        aria2c_stop
        [ -n "$1" ] \
            && add_url "$1" "$links_file"
        aria2c_start
        ;;
esac
