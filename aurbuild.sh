#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/aurbuild.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-02-15T06:20:56+0100

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# color variables for interactive shell
tty -s \
    && reset="\033[0m" \
    && bold="\033[1m" \
    && green="\033[32m"

# functions
create_tmp_env() {
    mkdir -m 0700 -p "$1"
    tmp_dir=$(mktemp --directory "$1/$sync_name.XXXXXX")
    trap 'rm -rf "$tmp_dir"' EXIT
}

create_pkg_list() {
    printf "%s" "$1" \
        | cut -d'	' -f1 \
        | grep -E "$2" 2>/dev/null \
        | aur fetch --existing --discard --sync=auto --results="$3" -
}

create_build_list() {
    # compare vcs heads
    while IFS=: read -r mode rev_old rev path; do
        pkg_name=${path##*/}
        case $mode in
            clone | merge | fetch | rebase | reset)
                [ "$rev" != 0 ] \
                    && [ "$rev" = "$rev_old" ] \
                    && case "$targets" in
                        "") targets=$(printf "%s" "$pkg_name");;
                        *)  targets=$(printf "%s\n%s" "$targets" "$pkg_name");;
                    esac
                ;;
        esac
    done < "$1"

    # compare db version with target version to build
    [ -n "$targets" ] \
        && printf "%s\n" "$targets" \
            | aur srcver - > "$tmp_dir/targets" \
        && printf "%s\n" "$2" \
            | aur vercmp --quiet --path="$tmp_dir/targets" > "$3"
}

build_pkgs() {
    [ -s "$1" ] \
        && aur build --syncdeps --rmdeps --noconfirm --nosync --arg-file "$1" \
        && return
    printf >&2 "%s: all packages are up to date\n" "$sync_name"
}

# main
# sync packages
aur sync --upgrades --rmdeps --noconfirm --noview --nosync

# sync devel packages
cd "/srv/aurutils/sync" || exit
sync_name="build"
create_tmp_env "/tmp/aurutils-$(id -u)"
local_db=$(aur repo --list)
pkg_filter="\-git$|\-cvs$|\-svn$|\-bzr$|\-darcs$|\-always$|\-hg$|\-fossil$"
printf >&2 "%b%b==>%b %bUsing [%s] package filter%b\n" \
        "$bold" "$green" "$reset" "$bold" "$pkg_filter" "$reset"
create_pkg_list "$local_db" "$pkg_filter" "$tmp_dir/pkgs"
create_build_list "$tmp_dir/pkgs" "$local_db" "$tmp_dir/builds"
build_pkgs "$tmp_dir/builds"
