#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/aria2c.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-03-11T11:25:51+0100

# config
links_file="$HOME/Public/downloads/links.txt"

# help
script=$(basename "$0")
help="$script [-h/--help] -- wrapper script to download with aria2c
  Usage:
    $script [-a/--add] <urls>

  Settings:
    without given settings, continue downloading from links file
    [-a/--add] = add urls to links file (don't restart aria2c)
    <urls>     = file links

  Examples:
    $script
    $script \"https://link.xyz/download1.tar.gz\" \"https://link.xyz/download2.tar.gz\"
    $script -a \"https://link.xyz/download1.tar.gz\" \"https://link.xyz/download2.tar.gz\"

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

add_urls() {
    urls=$(for url in "$@"; do
        printf "%s\n" "$url" \
            | grep -s -v "^-"
    done
    )

    [ -s "$links_file" ] \
        && links=$(grep -v " gid=" "$links_file") \
        && printf "%s\n%s\n" "$links" "$urls" \
            | tr -d '[:blank:]' \
            | sort -u > "$links_file" \
        && return 0

    printf "%s\n" "$urls" \
        | tr -d '[:blank:]' > "$links_file"
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -a | --add)
        [ -n "$2" ] \
            && add_urls "$@"
        ;;
    *)
        aria2c_stop
        [ -n "$1" ] \
            && add_urls "$@"
        aria2c_start
        ;;
esac
