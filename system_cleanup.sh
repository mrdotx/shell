#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/system_cleanup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-04-09T06:21:42+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

# color variables
reset="\033[0m"
bold="\033[1m"
green="\033[32m"
blue="\033[94m"
cyan="\033[96m"

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
    ! [ -f "$1" ] && printf "missing: %b%s%b\n" "$cyan" "$1" "$reset" && return

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
    ! [ -d "$1" ] && printf "missing: %b%s%b\n" "$cyan" "$1" "$reset" && return

    cache_files=$(find_files "$1" "$2" \
        | wc -l \
    )

    [ "$cache_files" -gt 0 ] \
        || return 0

    printf "%b%b::%b %bdelete %d files from%b %b%s%b %bnot accessed in %d days...%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$cache_files" "$reset" \
        "$cyan" "$1" "$reset" "$bold" "$2" "$reset"

    find_files "$1" "$2"

    printf "%b%b  ->%b delete files from %b%s%b [y]es/[N]o: " \
        "$bold" "$blue" "$reset" "$cyan" "$1" "$reset" \
        && read -r key
    case "$key" in
        y|Y|yes|Yes)
            find_files "$1" "$2" -delete
            ;;
    esac
}

delete_pkg_versions() {
    ! [ -d "$1" ] && printf "missing: %b%s%b\n" "$cyan" "$1" "$reset" && return

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
    ! [ -d "$1" ] && printf "missing: %b%s%b\n" "$cyan" "$1" "$reset" && return
    ! [ -d "$2" ] && printf "missing: %b%s%b\n" "$cyan" "$2" "$reset" && return

    pkgs_cache="$1"
    pkgs_all="$2/client_pkgs"
    pkgs_to_delete="$2/pkgs_to_delete.txt"
    pkgs_installed="$2/pkgs_installed.txt"
    pkgs_exceptions="$2/pkgs_exceptions.txt"

    printf "%b%b::%b %bdelete unused packages from%b %b%s%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$pkgs_cache" "$reset"

    # process packages to delete
    printf "%b%b==>%b create %b%s%b\n" \
        "$bold" "$green" "$reset" "$cyan" "$pkgs_to_delete" "$reset"
    find "$pkgs_cache" -type f -print0 \
        | xargs -0 basename -a 2>/dev/null \
        | sort -u > "$pkgs_to_delete"

    printf "%b%b==>%b create %b%s%b\n" \
        "$bold" "$green" "$reset" "$cyan" "$pkgs_installed" "$reset"
    cat "$pkgs_all"/pkgs_all_*.txt \
        | sort -u > "$pkgs_installed"

    printf "%b%b==>%b delete exceptions from %b%s%b\n" \
        "$bold" "$green" "$reset" "$cyan" "$pkgs_to_delete" "$reset"
    sort -u -r "$pkgs_exceptions" \
        | while IFS= read -r line; do
            sed -i "/^$line\-/d" "$pkgs_to_delete"
        done

    printf "%b%b==>%b delete installed packages from %b%s%b\n" \
        "$bold" "$green" "$reset" "$cyan" "$pkgs_to_delete" "$reset"
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

# files
cleanup_file "$HOME/.local/share/iwctl/history"
cleanup_file "$HOME/.local/share/cmd_history"
delete_files "$HOME/.cache" 365

# packages
case "$(uname -n)" in
    "m625q")
        for option in "$@"; do
            case "$option" in
                -u | --unused)
                    delete_unused_pkgs "/srv/pacman" "$HOME/Public/pkgsused"
                    ;;
                -v | --versions)
                    delete_pkg_versions "/srv/pacman/core/os/x86_64" 2
                    delete_pkg_versions "/srv/pacman/extra/os/x86_64" 2
                    delete_pkg_versions "/srv/aurutils/aurbuild" 2
                    ;;
            esac
        done
    ;;
esac
