#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/old/extractor.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-06-08T13:27:33+0200

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

extract() {
    execute="${1%% *}"
    if ! [ -x "$(command -v "$execute")" ]; then
        printf "\"%s\" is not installed\n" "$execute"
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
                extract "tar xvf $n"
                ;;
            *.tar.zst)
                extract "tar -I zstd -xvf $n"
                ;;
            *.cbz|*.epub|*.zip)
                extract "unzip $n"
                ;;
            *.cbr|*.rar)
                extract "unrar x -ad $n"
                ;;
            *.ace|*.cba)
                extract "unace x $n"
                ;;
            *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                extract "7z x $n"
                ;;
            *.gz)
                extract "gunzip $n"
                ;;
            *.bz2)
                extract "bunzip2 $n"
                ;;
            *.lzma)
                extract "unlzma $n"
                ;;
            *.cpio)
                extract "cpio -id < $n"
                ;;
            *.z)
                extract "uncompress $n"
                ;;
            *.xz)
                extract "unxz $n"
                ;;
            *.arc)
                extract "arc e $n"
                ;;
            *.zpaq)
                extract "zpaq x $n"
                ;;
            *.cso)
                extract "ciso 0 $n $n.iso"
                ;;
            *.exe)
                extract "cabextract $n"
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
