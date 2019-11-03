#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/pdfshrink.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:33:00

# settings
#    -dPDFSETTINGS=/screen      (72 dpi images)
#    -dPDFSETTINGS=/ebook       (150 dpi images)
#    -dPDFSETTINGS=/printer     (300 dpi images)
#    -dPDFSETTINGS=/prepress    (300 dpi images, color preserving)
#    -dPDFSETTINGS=/default

# variables {{{
PDFSETTING=screen
PDFFILE=$1
PDF=$(basename "$1" .pdf)
# }}}

# procedure {{{
if [[ $1 == "-h" || $1 == "--help" || $# -eq 0 ]]; then
    echo "Usage:"
    echo "	pdfshrink.sh [pdf filename]"
    echo
    echo "Example:"
    echo "	pdfshrink.sh document.pdf"
    echo
    exit 0
else
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/$PDFSETTING -dNOPAUSE -dBATCH -sOutputFile="$PDF"-compressed.pdf "$PDFFILE"
fi
# }}}
