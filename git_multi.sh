#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/git_multi.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-01-14T08:22:39+0100

# config
default="status"
procs=$(($(nproc --all) * 4))

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to execute git command on multiple repositories
  Usage:
    $script [git option] [path-1] [path-n]

  Settings:
    [git option] = option like fetch origin or pull (default=$default)
    [path]       = path to folder with n repositories

  Examples:
    $script
    $script \"fetch origin\" \"$HOME/.local/share/repos\"
    $script \"pull\" \"\$HOME/.local/share/repos\" \"/srv/http\""

# helper functions
git_folder() {
    folders="$(printf "%s" "${*:-$(pwd)}" \
        | sed 's/ /\n/g' \
    )"

    for folder in $folders; do
        find "$folder" -maxdepth 2 -type d -name ".git" \
            | sed 's/\/.git//' \
            | sort
    done
}

command_constructor() {
    # color variables
    green="\033[32m"
    yellow="\033[33m"
    reset="\033[0m"

    for folder in $1; do
        repo_folder="${folder%/*}"
        printf "\"printf '%%s  -> completed: %sgit %s %s%s%s\\\n'" \
            "$green" \
            "$options" \
            "$yellow" \
            "${repo_folder##*/}/${folder##*/}" \
            "$reset"
        printf " \"\$(cd %s && git %s)\"\"\n" \
            "$folder" \
            "$options"
    done
}

case $1 in
    -h | --help)
        printf "%s\n" "$help"
        exit 0
        ;;
    */*)
        options="$default"
        ;;
    *)
        options="${1:-$default}"
        [ $# -ge 1 ] \
            && shift
esac

printf ":: git operations:\n"
command_constructor "$(git_folder "$@")" \
    | xargs -P"$procs" -I{} sh -c '{}'
