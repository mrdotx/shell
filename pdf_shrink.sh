#!/bin/sh

# path:       ~/projects/shell/pdf_shrink.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-02-03T13:47:41+0100

script=$(basename "$0")
help="$script [-h/--help] -- script to shrink pdf files
  Usage:
    $script [pdf setting] [pdf filename]

  Settings:
    [pdf setting]  = name of the compression format
      screen       = (72 dpi images)
      ebook        = (150 dpi images)
      printer      = (300 dpi images)
      prepress     = (300 dpi images, color preserving)
    [pdf filename] = name of the file to be compress

  Example:
    $script screen document.pdf"

pdf_setting=$1
pdf_file=$2
pdf_name=$(basename "$2" .pdf)

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$2" ] || [ $# -eq 0 ]; then
    echo "$help"
    exit 0
else
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/"$pdf_setting" -dNOPAUSE -dBATCH -sOutputFile="$pdf_name"-compressed.pdf "$pdf_file"
fi
