#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/aurbuild.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-02-01T05:15:13+0100

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

# functions
create_tmp_env() {
    mkdir -m 0700 -p "$1"
    tmp_dir=$(mktemp --directory "$1/$sync_name.XXXXXX")
    trap 'rm -rf "$tmp_dir"' EXIT
}

create_fetch_list() {
    vcs_filter="\-git$|\-cvs$|\-svn$|\-bzr$|\-darcs$|\-always$|\-hg$|\-fossil$"
    printf "%s" "$1" \
        | cut -d'	' -f1 \
        | grep -E "$vcs_filter" 2>/dev/null \
        | aur fetch --existing --discard --sync=auto --results="$2" -
}

create_build_list() {
    # compare vcs heads
    while IFS=: read -r mode rev_old rev path; do
        vcs_name=${path##*/}
        case $mode in
            clone | merge | fetch | rebase | reset)
                [ "$rev" != 0 ] \
                    && [ "$rev" = "$rev_old" ] \
                    && case "$targets" in
                        "") targets=$(printf "%s" "$vcs_name");;
                        *)  targets=$(printf "%s\n%s" "$targets" "$vcs_name");;
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

build_pks() {
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
create_fetch_list "$local_db" "$tmp_dir/fetch"
create_build_list "$tmp_dir/fetch" "$local_db" "$tmp_dir/builds"
build_pks "$tmp_dir/builds"
