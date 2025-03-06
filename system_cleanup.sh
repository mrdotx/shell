#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/system_cleanup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-03-06T05:51:51+0100

# color variables
reset="\033[0m"
bold="\033[1m"
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
    ! [ -f "$1" ] \
        && return 0

    printf "%b%b::%b %bCLEANUP%b file %b%s%b\n" \
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
        && return 0

    cache_files=$(find_files "$1" "$2" \
        | wc -l \
    )

    [ "$cache_files" -gt 0 ] \
        || return 0

    printf "\n%b%b::%b %bDELETE%b %d files from %b%s%b not accessed in %d days...\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cache_files" "$cyan" "$1" "$reset" \
        "$2"

    find_files "$1" "$2"

    printf "%b%b  ->%b %bDELETE%b files from %b%s%b [y]es/[N]o: " \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$1" "$reset" \
        && read -r key
    case "$key" in
        y|Y|yes|Yes)
            find_files "$1" "$2" -delete
            ;;
    esac
}

delete_pkgs() {
    ! [ -d "$1" ] \
        && return 0

    auth="${EXEC_AS_USER:-sudo}"

    dry_run=$($auth find "$1" -type d \
        -exec printf "%b%b::%b %bDELETE%b pkgs from %b{}%b, except last %s versions\n" \
            "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$reset" "$2" \; \
        -exec paccache -dvk "$2" -c {} \; \
    )

    printf "%s\n" \
        "$dry_run" \
        | grep -q "Candidate packages:" \
        || return 0

    printf "\n%s\n" \
        "$dry_run"
    printf "%b%b  ->%b %bDELETE%b pkgs from %b%s%b [y]es/[N]o: " \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$1" "$reset" \
        && read -r clear_pkgs \
        && case "$clear_pkgs" in
            y|Y|yes|Yes)
                $auth find "$1" -type d \
                    -exec paccache -rvk "$2" -c {} \;
                ;;
        esac
}

# main
cleanup_file "$HOME/.local/share/iwctl/history"
printf "\n"
cleanup_file "$HOME/.local/share/cmd_history"
delete_files "$HOME/.cache" 365
delete_pkgs "/srv/pacman/core/os/x86_64" 2
delete_pkgs "/srv/pacman/extra/os/x86_64" 2
delete_pkgs "/srv/aurutils/aurbuild" 2
