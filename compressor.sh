#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/compressor.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-02-17T07:18:06+0100

commands() {
    cmds="7z bzip2 gzip lzip lzma lzop tar xz zstd"

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
help="$script [-h/--help] -- script to extract/compress/list files and folders
  Usage:
    $script [--add/--list] <quality> <file>.<ext> [file1.ext] [file2.ext]

  Settings:
    [--add]   = compress files and folders to archive
    [--list]  = list archive files and folders
    <ext>     = compression extensions:
                  7z, tar, tar.bz2, tar.gz, tar.lz, tar.lzma, tar.lzo, tar.xz,
                  tar.z, tar.zst, taz, tbz, tbz2, tgz, tlz, txz, tz2, tzo, tzst,
                  zip
                decompression extensions:
                  7z, a, alz, apk, arj, bz, bz2, bzip2, cab, cb7, cbr, cbt, cbz,
                  chm, chw, cpio, deb, dmg, doc, epub, exe, gz, gzip, hxs, img,
                  iso, jar, lha, lz, lzh, lzma, lzo, msi, pkg, ppt, rar, rpm,
                  swm, tar, taz, tbz, tbz2, tgz, tlz, txz, tz2, tzo, tzst, udf,
                  war, wim, xar, xls, xpi, xz, z, zip, zst

  Examples:
    $script file1.tar.gz file2.tar.bz2 file3.7z
    $script --add archive.tar.gz file1.ext file2.ext file3.ext
    $script --list file1.tar.gz file2.tar.bz2 file3.7z

  Commands:
    required for full functionality (X = available): $(commands)"

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
                            tar tvf "$archive"
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
                    | *.a | *.alz | *.apk | *.arj | *.bz | *.bz2 | *.bzip2 \
                    | *.cab | *.cb7 | *.cbr | *.cbt | *.cbz | *.chm | *.chw \
                    | *.cpio | *.deb | *.dmg | *.doc | *.epub | *.exe | *.gz \
                    | *.gzip | *.hxs | *.img | *.iso | *.jar | *.lha | *.lz \
                    | *.lzh | *.lzma | *.lzo | *.msi | *.pkg | *.ppt | *.rar \
                    | *.rpm | *.swm | *.udf | *.war | *.wim | *.xar | *.xls \
                    | *.xpi | *.xz | *.z | *.zip | *.zst)
                    case "$list" in
                        1)
                            7z l -p "$archive" \
                                | tail +2 # WORKAROUND: 7z first line empty
                            ;;
                        *)
                            printf "7z x \"%s\" -o\"%s\"\n" \
                                "$archive" "$folder"
                            mkdir -p "$folder"
                            7z x "$archive" -o"$folder" >/dev/null 2>&1
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
    *)
        extract "$@"
        ;;
esac
