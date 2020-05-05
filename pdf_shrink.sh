#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/pdf_shrink.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-05T14:34:24+0200

script=$(basename "$0")
help="$script [-h/--help] -- script to shrink pdf files
  Usage:
    $script [setting] [filename]

  Settings:
    [setting]   = name of the compression format
      screen    = (72 dpi images)
      ebook     = (150 dpi images)
      printer   = (300 dpi images)
      prepress  = (300 dpi images, color preserving)
    [filename]  = name of the file to be compress

  Example:
    $script screen document.pdf"

setting=$1
file=$2
name=$(basename "$2" .pdf)

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$2" ] || [ $# -eq 0 ]; then
    printf "%s\n" "$help"
    exit 0
else
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/"$setting" -dNOPAUSE -dBATCH -sOutputFile="$name"-compressed.pdf "$file"
fi
