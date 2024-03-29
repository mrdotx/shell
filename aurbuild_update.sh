#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/aurbuild_update.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-07-31T09:11:25+0200

# speed up script and avoid language problems by using standard c
LC_ALL=C
LANG=C

## sync packages
aur sync --upgrades --rmdeps --noconfirm --noview --nosync

## sync devel packages
set -e
sync_name="sync_devel"
sync_dir="/srv/aurutils/sync"

# create tmp environment
uid=$(id -u)
mkdir -p "/tmp/aurutils-$uid" \
    && chmod 0700 "/tmp/aurutils-$uid"
tmp=$(mktemp --directory --tmpdir "aurutils-$uid/$sync_name.XXXXXX")
trap 'rm -rf "$tmp"' EXIT

# get packages and potential vcs packages from local db
db=$(aur repo --list)
vcs() {
    printf "%s" "$db" \
        | cut -d'	' -f1 \
        | grep -E "$1" 2>/dev/null
}

# fetch aur to compare vcs heads
cd "$sync_dir"
vcs "\-git$|\-cvs$|\-svn$|\-bzr$|\-darcs$|\-always$|\-hg$|\-fossil$" \
    | aur fetch --existing --discard --sync "auto" --results "$tmp/fetch" -

while IFS=: read -r mode rev_old rev path; do
    vcs_name=${path##*/}

    case $mode in
        clone | merge | fetch | rebase | reset)
            [ "$rev" != 0 ] \
                && [ "$rev" = "$rev_old" ] \
                && case "$targets" in
                    "")
                        targets=$(printf "%s" "$vcs_name")
                        ;;
                    *)
                        targets=$(printf "%s\n%s" "$targets" "$vcs_name")
                        ;;
                esac
            ;;
    esac
done < "$tmp/fetch"

# compare db version with target version to build
[ -n "$targets" ] \
    && printf "%s\n" "$targets" \
        | aur srcver - > "$tmp/targets" \
    && printf "%s\n" "$db" \
        | aur vercmp --quiet --path "$tmp/targets" > "$tmp/builds"

# rebuild the updateable packages
[ -s "$tmp/builds" ] \
    && aur build --syncdeps --rmdeps --noconfirm --nosync \
        --arg-file "$tmp/builds" \
    && exit 0

printf "%s: all packages up-to-date\n" "$sync_name"
