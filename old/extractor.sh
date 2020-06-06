#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/old/extractor.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-06-06T09:27:52+0200

script=$(basename "$0")
help="$script [-h/--help] -- script to extract files
  Usage:
    $script <file_name_1> [file_name_2]

  Example:
    $script test.zip
    $script test_1.tar.gz test_2.tar.gz"

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -eq 0 ]; then
    printf "%s\n" "$help"
    exit 0
fi

ext() {
    cmd="${1%% *}"
    if ! [ -x "$(command -v "$cmd")" ]; then
        printf "\"%s\" is not installed\n" "$cmd"
        exit 1
    else
        $1
    fi
}

for n in "$@"
do
    if [ -f "$n" ] ; then
        case "${n%,}" in
            *.cbt|*.tar|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz)
                ext "tar xvf $n"
                ;;
            *.tar.zst)
                ext "tar -I zstd -xvf $n"
                ;;
            *.cbz|*.epub|*.zip)
                ext "unzip $n"
                ;;
            *.cbr|*.rar)
                ext "unrar x -ad $n"
                ;;
            *.ace|*.cba)
                ext "unace x $n"
                ;;
            *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                ext "7z x $n"
                ;;
            *.gz)
                ext "gunzip $n"
                ;;
            *.bz2)
                ext "bunzip2 $n"
                ;;
            *.lzma)
                ext "unlzma $n"
                ;;
            *.cpio)
                ext "cpio -id < $n"
                ;;
            *.z)
                ext "uncompress $n"
                ;;
            *.xz)
                ext "unxz $n"
                ;;
            *.arc)
                ext "arc e $n"
                ;;
            *.zpaq)
                ext "zpaq x $n"
                ;;
            *.cso)
                ext "ciso 0 $n $n.iso"
                ;;
            *.exe)
                ext "cabextract $n"
                ;;
            *)
                printf "\"%s\" has an unknown extension\n" "$n"
                exit 1
                ;;
        esac
    else
        printf "\"%s\" does not exist\n" "$n"
        exit 1
    fi
done
