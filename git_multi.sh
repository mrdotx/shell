#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/git_multi.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2025-03-27T06:03:34+0100

# config
default="status"
procs=$(($(nproc --all) * 4))

# color variables
reset="\033[0m"
bold="\033[1m"
green="\033[32m"
blue="\033[94m"
cyan="\033[96m"

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
    for folder in $1; do
        repo_folder="${folder%/*}"
        printf "\"git -C %s %s" \
            "$folder" "$options"
        printf " && printf '%b%b==>%b completed: %bgit%b %s %b%s%b\\\n'\"\n" \
            "$bold" "$green" "$reset" "$green" "$reset" "$options" "$cyan" \
            "${repo_folder##*/}/${folder##*/}" "$reset"
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

printf "%b%b::%b %bexecute git operations:%b\n" \
    "$bold" "$blue" "$reset" "$bold" "$reset"
command_constructor "$(git_folder "$@")" \
    | xargs -P"$procs" -I{} sh -c '{}'
