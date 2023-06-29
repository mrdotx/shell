#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/system_cleanup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-06-29T18:04:12+0200

# helper
find_files() {
    cache_directory="$1"
    cache_days="$2"
    shift 2

    find "$cache_directory" \
        -type f \
        -mtime +"$cache_days" \
        -not -path "*/paru/*" \
        "$@"
}

cleanup_file() {
    ! [ -f "$1" ] \
        && return 0

    printf ":: cleanup file \"%s\"\n" \
        "$1"
    printf " remove white space from the end of the line...\n"
    sed -i 's/ *$//' "$1"

    printf " remove duplicates...\n"
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

    printf "\n:: delete %d files from \"%s\" not accessed in %d days...\n" \
        "$cache_files" \
        "$1" \
        "$2"

    find_files "$1" "$2"

    printf " delete files from \"%s\" [y]es/[N]o: " \
        "$1" \
        && read -r "key"
    case "$key" in
        y|Y|yes|Yes)
            find_files "$1" "$2" -delete
            ;;
        *)
            ;;
    esac
}

delete_pkgs() {
    ! [ -d "$1" ] \
        && return 0

    auth="${EXEC_AS_USER:-sudo}"

    dry_run=$($auth find "$1" -type d \
        -exec printf "\n:: delete pkgs from \"{}\", except last %s versions\n" \
            "$2" \; \
        -exec paccache -dvk "$2" -c {} \; \
    )

    printf "%s\n" \
        "$dry_run" \
        | grep -q "Candidate packages:" \
        || return 0

    printf "\n%s\n" \
        "$dry_run"
    printf " delete pkgs from \"%s\" [y]es/[N]o: " \
        "$1" \
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
