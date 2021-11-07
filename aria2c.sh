#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/aria2c.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-11-07T19:10:29+0100

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

start_aria2c() {
    pid=$(pgrep aria2c$)
    [ -n "$pid" ] \
        && kill "$pid"
    aria2c \
        -i "$links_file" \
        --save-session="$links_file" \
        --save-session-interval=60
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    *)
        [ -n "$1" ] \
            && printf "%s\n" "$1" >> "$links_file"
        start_aria2c
        ;;
esac
