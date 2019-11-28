#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/pdf_shrink.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 14:15:00

pdfsetting=$1
pdffile=$2
pdf=$(basename "$2" .pdf)

# shrink pdf in different dpi
if [[ $1 == "-h" || $1 == "--help" || -z $2 || $# -eq 0 ]]; then
    echo "Usage:"
    echo "  pdfshrink.sh [pdf setting] [pdf filename]"
    echo
    echo "Setting:"
    echo "  screen      (72 dpi images)"
    echo "  ebook       (150 dpi images)"
    echo "  printer     (300 dpi images)"
    echo "  prepress    (300 dpi images, color preserving)"
    echo
    echo "Example:"
    echo "  pdfshrink.sh screen document.pdf"
    echo
    exit 0
else
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/"$pdfsetting" -dNOPAUSE -dBATCH -sOutputFile="$pdf"-compressed.pdf "$pdffile"
fi
