#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/pdf.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2025-08-11T04:50:36+0200

commands() {
    cmds="ghostscript magick"

    printf "\n"
    for cmd in $cmds; do
        if command -v "$cmd" > /dev/null 2>&1; then
            printf "      [X] %s\n" "$cmd"
        else
            printf "      [ ] %s\n" "$cmd"
        fi
    done
}

script=$(basename "$0")
help="$script [-h/--help] -- script to compress/convert/chain/unchain pdf files
  Usage:
    $script [--compress/--convert/--un/-chain] <quality> <file>.<ext> [file1.ext]

  Settings:
    [--compress]  = compress pdf files
    <quality>     = pdf quality settings (default: default)
                      default  = useful across a wide variety of uses ( 72ppi)
                                 (possible larger file size)
                      screen   = low-resolution                       ( 72ppi)
                      ebook    = medium-resolution                    (150ppi)
                      printer  = high-resolution                      (300ppi)
                      prepress = very high-resolution                 (300ppi)
                      all      = create for each quality setting a file
    [--convert]   = convert images into pdf file
    <quality>     = pdf quality settings (default: text)
                      text     = low-resolution                       ( 72ppi)
                      screen   = medium-resolution                    ( 96ppi)
                      ebook    = high-resolution                      (150ppi)
                      print    = very high-resolution                 (300ppi)
                      all      = create for each quality setting a file
    [--un/-chain] = chain and unchain pdf files

  Examples:
    $script --compress ebook document1.pdf document2.pdf document3.pdf
    $script --convert screen image1.jpg image2.jpg image3.jpg
    $script --chain document1.pdf document2.pdf document3.pdf
    $script --unchain document1.pdf document2.pdf document3.pdf

  Commands:
    required for full functionality (X = available): $(commands)"

unchain_pdf() {
    for pdf in "$@"; do
        output_file="$(basename "$pdf" .pdf)"
        printf "==> %s.pdf\n" "$output_file"

        ghostscript \
            -sDEVICE=pdfwrite \
            -dNOPAUSE \
            -dBATCH \
            -sOutputFile="${output_file}_%03d.pdf" \
            "$pdf"
    done
}

compress_pdf() {
    case $1 in
        screen | ebook | printer | prepress | default)
            quality="$1"
            shift
            ;;
        *)
            quality="default"
            ;;
    esac

    for document in "$@"; do
        output_file="$(basename "$document" .pdf)-$quality.pdf"
        printf "==> %s\n" "$output_file"

        ghostscript \
            -sDEVICE=pdfwrite \
            -dPDFSETTINGS=/"$quality" \
            -dPrinted=false \
            -dNOPAUSE \
            -dBATCH \
            -sOutputFile="$output_file" \
            "$document"
    done
}

convert_image() {
    # a4 width: 297mm / 25.4mm ≈ 11,6929 inch * ppi
    case "$1" in
        text)   #  72 ppi ≈  842 pixel
            width="842"
            quality="$1"
            shift
            ;;
        screen) #  96 ppi ≈ 1123 pixel
            width="1123"
            quality="$1"
            shift
            ;;
        ebook)  # 150 ppi ≈ 1754 pixel
            width="1754"
            quality="$1"
            shift
            ;;
        print)  # 300 ppi ≈ 3508 pixel
            width="3508"
            quality="$1"
            shift
            ;;
        *)
            width="842"
            quality="text"
            exit 1
    esac

    magick "$@" -verbose -auto-orient -resize "${width}x-1" "image_$quality.pdf"
}

case "$1" in
    -h | --help | "")
        printf "%s\n" "$help"
        ;;
    --chain)
        shift
        ghostscript \
            -sDEVICE=pdfwrite \
            -dNOPAUSE \
            -dBATCH \
            -sOutputFile="chain.pdf" \
            "$@"
        ;;
    --unchain)
        shift
        unchain_pdf "$@"
        ;;
    --compress)
        shift
        case "$1" in
            all)
                shift
                for quality in screen ebook printer prepress default; do
                    compress_pdf "$quality" "$@"
                done
                ;;
            *)
                compress_pdf "$@"
                ;;
        esac
        ;;
    --convert)
        shift
        case "$1" in
            all)
                shift
                for quality in text screen ebook print; do
                    convert_image "$quality" "$@"
                done
                ;;
            *)
                convert_image "$@"
                ;;
        esac
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac
