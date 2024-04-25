#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/compressor.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-04-24T20:50:12+0200

check() {
    tools="7z bzip2 ghostscript gzip lzip lzma lzop tar unzip xz zstd"

    printf "\n"
    for tool in $tools; do
        if command -v "$tool" > /dev/null 2>&1; then
            printf "      [ ] %s\n" "$tool"
        else
            printf "      [X] %s\n" "$tool"
        fi
    done
}

script=$(basename "$0")
help="$script [-h/--help] -- script to extract/compress/list files and folders
  Usage:
    $script [--add/--list/--pdf] <quality> <file>.<ext> [file1.ext] [file2.ext]

  Settings:
    [--add]   = compress files and folders to archive
    [--list]  = list archive files and folders
    <ext>     = compression extensions:
                  7z, tar, tar.bz2, tar.gz, tar.lz, tar.lzma, tar.lzo, tar.xz,
                  tar.z, tar.zst, taz, tbz, tbz2, tgz, tlz, txz, tz2, tzo, tzst,
                  zip
                decompression extensions:
                  7z, a, alz, apk, arj, bz, bz2, bzip2, cab, cb7, cbr, cbt, cbz,
                  chm, chw, cpio, deb, dmg, doc, epub, exe, gz, gzip, hxs, iso,
                  jar, lha, lz, lzh, lzma, lzo, msi, pkg, ppt, rar, rpm, swm,
                  tar, taz, tbz, tbz2, tgz, tlz, txz, tz2, tzo, tzst, udf, war,
                  wim, xar, xls, xpi, xz, z, zip, zst
    [--pdf]   = compress pdf files
    <quality> = pdf quality settings (default: default)
                  screen   = low-resolution
                  ebook    = medium-resolution
                  printer  = high-resolution
                  prepress = very high-resolution
                  default  = useful across a wide variety of uses
                             (possible larger file size)
                  all      = create for each quality setting a file

  Examples:
    $script file1.tar.gz file2.tar.bz2 file3.7z
    $script --add archive.tar.gz file1.ext file2.ext file3.ext
    $script --list file1.tar.gz file2.tar.bz2 file3.7z
    $script --pdf ebook document1.pdf document2.pdf document3.pdf

  Commands:
    tools required for full functionality (X: missing commands): $(check)"

compress() {
    archive="$1"
    shift

    case "$archive" in
        *.tar \
            | *.tar.bz2 | *.tar.gz | *.tar.lz | *.tar.lzma | *.tar.lzo \
            | *.tar.xz | *.tar.z | *.tar.zst | *.taz | *.tbz | *.tbz2 \
            | *.tgz | *.tlz | *.txz | *.tz2 | *.tzo | *.tzst)
            tar cvfa "$archive" "$@"
            ;;
        *.zip)
            7z a -tzip "$archive" "$@"
            ;;
        *.7z)
            7z a "$archive" "$@"
            ;;
        *)
            printf "compress: unknown extension\n"
            exit 1
            ;;
    esac
}

extract() {
    [ "$1" = "--list" ] \
        && list=1 \
        && shift

    for archive in "$@"; do
        if [ -f "$archive" ]; then
            base="$(printf "%s" "${archive##*/}" \
                    | tr '[:upper:]' '[:lower:]')"
            folder="${base%.*}"
            case "$base" in
                *.tar \
                    | *.tar.bz2 | *.tar.gz | *.tar.lz | *.tar.lzma | *.tar.lzo \
                    | *.tar.xz | *.tar.z | *.tar.zst | *.taz | *.tbz | *.tbz2 \
                    | *.tgz | *.tlz | *.txz | *.tz2 | *.tzo | *.tzst)
                    case "$list" in
                        1)
                            tar tf "$archive"
                            ;;
                        *)
                            folder="${folder%%.tar}"
                            printf "tar xvf \"%s\" -C \"%s\"\n" \
                                "$archive" "$folder"
                            mkdir -p "$folder"
                            tar xvf "$archive" -C "$folder" >/dev/null 2>&1
                            ;;
                    esac
                    ;;
                *.7z \
                    | *.a | *.alz | *.arj | *.bz | *.bz2 | *.bzip2 | *.cab \
                    | *.cb7 | *.cbr | *.cbt | *.cbz | *.chm | *.chw | *.cpio \
                    | *.deb | *.dmg | *.doc | *.epub | *.exe | *.gz | *.gzip \
                    | *.hxs | *.iso | *.jar | *.lha | *.lz | *.lzh | *.lzma \
                    | *.lzo | *.msi | *.pkg | *.ppt | *.rar | *.rpm | *.swm \
                    | *.udf | *.war | *.wim | *.xar | *.xls | *.xpi | *.xz \
                    | *.z | *.zip | *.zst)
                    case "$list" in
                        1)
                            7z l -p "$archive"
                            ;;
                        *)
                            printf "7z x \"%s\" -o\"%s\"\n" \
                                "$archive" "$folder"
                            mkdir -p "$folder"
                            7z x "$archive" -o"$folder" >/dev/null 2>&1
                            ;;
                    esac
                    ;;
                *.apk)
                    # WORKAROUND: 7z problems with bad header apks
                    case "$list" in
                        1)
                            unzip -l -P '' "$archive"
                            ;;
                        *)
                            printf "unzip \"%s\" -d \"%s\"\n" \
                                "$archive" "$folder"
                            mkdir -p "$folder"
                            unzip "$archive" -d "$folder" >/dev/null 2>&1
                            ;;
                    esac
                    ;;
                *)
                    case "$list" in
                        1) option="list";;
                        *) option="extract";;
                    esac

                    printf "%s \"%s\": unknown archive method\n" \
                        "$option" "$archive"
                    exit 1
                    ;;
            esac
        else
            case "$list" in
                1) option="list";;
                *) option="extract";;
            esac

            printf "%s \"%s\": file does not exist\n" \
                "$option" "$archive"
            exit 1
        fi
    done
}

compress_pdf() {
    case $1 in
        screen | ebook | printer | prepress | default)
            settings="$1"
            shift
            ;;
        all)
            settings="screen ebook printer prepress default"
            shift
            ;;
        *)
            settings="default"
            ;;
    esac

    for document in "$@"; do
        for setting in $settings; do
            output_file="$(basename "$document" .pdf)-$setting.pdf"
            printf "==> %s\n" "$output_file"

            ghostscript \
                -sDEVICE=pdfwrite \
                -dPDFSETTINGS=/"$setting" \
                -dPrinted=false \
                -dNOPAUSE \
                -dBATCH \
                -sOutputFile="$output_file" \
                "$document"
        done
    done
}

case "$1" in
    -h | --help | "")
        printf "%s\n" "$help"
        ;;
    --list)
        shift
        extract --list "$@"
        ;;
    --add)
        shift
        compress "$@"
        ;;
    --pdf)
        shift
        compress_pdf "$@"
        ;;
    *)
        extract "$@"
        ;;
esac
