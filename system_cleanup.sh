#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/system_cleanup.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-04-13T05:30:57+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

# color variables for the interactive shell
tty -s \
    && reset="\033[0m" \
    && bold="\033[1m" \
    && blue="\033[94m" \
    && cyan="\033[96m"

# helper
find_files() {
    cache_directory="$1"
    cache_days="$2"
    shift 2

    find "$cache_directory" \
        -type f \
        -mtime +"$cache_days" \
        -not -path "*/paru/*" \
        -not -name "wallpaper.jpg" \
        "$@"
}

cleanup_file() {
    ! [ -f "$1" ] \
        && return

    printf "%b%b::%b %bcleanup file%b %b%s%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$1" "$reset"
    printf "remove white space from the end of the line...\n"
    sed -i 's/ *$//' "$1"

    printf "remove duplicates...\n"
    printf "%s\n" "$(tac "$1" \
        | awk '! seen[$0]++' \
        | tac \
    )" > "$1"
}

delete_files() {
    ! [ -d "$1" ] \
        && return

    # process files to be deleted
    cache_files=$(find_files "$1" "$2" \
        | wc -l \
    )

    [ "$cache_files" -gt 0 ] \
        || return 0

    printf "%b%b::%b %bdelete %d files from%b %b%s%b %bnot accessed in %d days...%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$cache_files" "$reset" \
        "$cyan" "$1" "$reset" "$bold" "$2" "$reset"

    find_files "$1" "$2"

    # delete files from cache
    printf "%b%b  ->%b delete files from %b%s%b [y]es/[N]o: " \
        "$bold" "$blue" "$reset" "$cyan" "$1" "$reset" \
        && read -r key
    case "$key" in
        y|Y|yes|Yes)
            find_files "$1" "$2" -delete
            ;;
    esac
}

kodi_files() {
    ! [ -d "$1" ] \
        && return

    # process files to be deleted
    cache_dirs=$( \
        find "$1" -type d \
            -name "cache" -or \
            -name "temp" -or \
            -name "Thumbnails" -or \
            -name "packages"
    )

    cache_files=$( \
        for line in $cache_dirs; do
            find "$line" -type f \
                ! -name "kodi*.log"
        done
    )

    [ -n "$cache_files" ] \
        || return 0

    # delete files from cache
    printf "%b%b::%b %bdelete files from%b %b%s%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$1" "$reset"

    printf "%s\n" "$cache_files"

    printf "%b%b  ->%b delete files from %b%s%b [y]es/[N]o: " \
        "$bold" "$blue" "$reset" "$cyan" "$1" "$reset" \
        && read -r clean \
        && case "$clean" in
            y|Y|yes|Yes)
                for line in $cache_files; do
                    rm -f -v "$line"
                done
                ;;
        esac
}

delete_pkg_versions() {
    ! [ -d "$1" ] \
        && return

    # process packages to be deleted
    dry_run=$($auth find "$1" -type d \
        -exec printf "%b%b::%b %bdelete packages from%b %b{}%b%b, except the last %d versions%b\n" \
            "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$reset" \
            "$bold" "$2" "$reset" \; \
        -exec paccache -dvk "$2" -c {} \; \
        | sed '/^$/d' \
    )

    printf "%s" "$dry_run" \
        | grep -q "Candidate packages:" \
        || return 0

    # delete packages from cache
    printf "%s\n" "$dry_run"
    printf "%b%b  ->%b delete packages from %b%s%b [y]es/[N]o: " \
        "$bold" "$blue" "$reset" "$cyan" "$1" "$reset" \
        && read -r clear_pkgs \
        && case "$clear_pkgs" in
            y|Y|yes|Yes)
                $auth find "$1" -type d \
                    -exec paccache -rvk "$2" -c {} \; \
                    | sed '/^$/d'
                ;;
        esac
}

delete_unused_pkgs() {
    ! [ -d "$1" ] \
        && return
    ! [ -d "$2" ] \
        && return

    # process packages to be deleted
    pkgs_cache="$1"
    pkgs_all="$2/client_pkgs"
    pkgs_to_delete="$2/pkgs_to_delete.txt"
    pkgs_installed="$2/pkgs_installed.txt"
    pkgs_exceptions="$2/pkgs_exceptions.txt"

    printf "%b%b::%b %bdelete unused packages from%b %b%s%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$pkgs_cache" "$reset"

    printf "processing the packages...\n"
    find "$pkgs_cache" -type f -print0 \
        | xargs -0 basename -a 2>/dev/null \
        | sort -u > "$pkgs_to_delete"

    cat "$pkgs_all"/pkgs_all*.txt \
        | sort -u > "$pkgs_installed"

    sort -u -r "$pkgs_exceptions" \
        | while IFS= read -r line; do
            sed -i "/^$line\-/d" "$pkgs_to_delete"
        done

    sort -u -r "$pkgs_installed" \
        | while IFS= read -r line; do
            sed -i "/^$line\-[A-Z0-9]/d" "$pkgs_to_delete"
        done

    # delete packages from cache
    [ -s "$pkgs_to_delete" ] \
        && cat "$pkgs_to_delete" \
        && printf "%b%b  ->%b delete unused packages from %b%s%b [y]es/[N]o: " \
            "$bold" "$blue" "$reset" "$cyan" "$pkgs_cache" "$reset" \
        && read -r delete_cache

    case "$delete_cache" in
        y|Y|yes|Yes)
            while IFS= read -r line ;do
                $auth find "$pkgs_cache" -name "$line" -delete
            done < "$pkgs_to_delete"
            ;;
    esac
}

# main
cleanup_file "$HOME/.local/share/iwctl/history"
cleanup_file "$HOME/.local/share/cmd_history"

delete_files "$HOME/.cache" 365

kodi_files "$HOME/.local/share/kodi"

delete_pkg_versions "/srv/pkgs/archlinux/core/os/x86_64" 2
delete_pkg_versions "/srv/pkgs/archlinux/extra/os/x86_64" 2
delete_pkg_versions "/srv/pkgs/aurbuild" 2
delete_pkg_versions "/srv/pkgs/custombuild" 2

delete_unused_pkgs "/srv/pkgs/archlinux" "$HOME/Public/pkgsused"
