#!/bin/sh

# path:       ~/coding/shell/pdf_shrink.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 13:46:22

pdf_setting=$1
pdf_file=$2
pdf=$(basename "$2" .pdf)

# shrink pdf in different dpi
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$2" ] || [ $# -eq 0 ]; then
    echo "Usage:"
    echo "  pdf_shrink.sh [pdf setting] [pdf filename]"
    echo
    echo "Setting:"
    echo "  screen      (72 dpi images)"
    echo "  ebook       (150 dpi images)"
    echo "  printer     (300 dpi images)"
    echo "  prepress    (300 dpi images, color preserving)"
    echo
    echo "Example:"
    echo "  pdf_shrink.sh screen document.pdf"
    echo
    exit 0
else
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/"$pdf_setting" -dNOPAUSE -dBATCH -sOutputFile="$pdf"-compressed.pdf "$pdf_file"
fi
