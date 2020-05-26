#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/pdf_shrink.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-26T12:40:50+0200

script=$(basename "$0")
help="$script [-h/--help] -- script to shrink pdf files
  Usage:
    $script [setting] [filename]
    $script [filename]

    without [setting], the setting can be selected interactivly
    default is screen

  Settings:
    [setting]   = name of the compression format
      screen    = (72 dpi images)
      ebook     = (150 dpi images)
      printer   = (300 dpi images)
      prepress  = (300 dpi images, color preserving)
    [filename]  = name of the file to be compress

  Example:
    $script screen document.pdf
    $script document.pdf"

setting=$1
file=$2

format(){
    printf "\n\r%s" \
        ":: which compression format [S]creen/[e]book/[p]rinter/p[r]epress: " \
        && read -r "key"
    case "$key" in
        e|E)
            setting="ebook"
            ;;
        p|P)
            setting="printer"
            ;;
        r|R)
            setting="prepress"
            ;;
        *)
            setting="screen"
            ;;
    esac
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -eq 0 ]; then
    printf "%s\n" "$help"
    exit 0
else
    [ $# -eq 1 ] && format && file=$1
    name=$(basename "$file" .pdf)
    gs \
        -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dPDFSETTINGS=/"$setting" \
        -dNOPAUSE \
        -dBATCH \
        -sOutputFile="$name"-compressed.pdf "$file"
fi
