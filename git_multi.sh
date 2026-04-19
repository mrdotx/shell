#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/git_multi.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/shell
# date:   2026-04-19T05:25:50+0200

# config
default="status"
procs=$(($(nproc --all) * 4))

# color variables for the interactive shell
tty -s \
    && reset="\033[0m" \
    && bold="\033[1m" \
    && green="\033[32m" \
    && cyan="\033[96m"

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to execute git command on multiple repositories
  Usage:
    $script [git option] [path-1] [path-n]

  Settings:
    [git option] = option like fetch origin or pull (default=$default)
    [path]       = path to directory with n repositories
                   (if this is a .git directory, the parent directory is used)

  Examples:
    $script
    $script \"fetch origin\" \"$HOME/.local/share/repos\"
    $script \"pull\" \"\$HOME/.local/share/repos\" \"/srv/http\""

# helper functions
git_directory() {
    directories="$(printf "%s" "${*:-$(pwd)}" \
        | sed 's/ /\n/g' \
    )"

    for directory in $directories; do
        find "$directory" -type d -name ".git" \
            | sed -e 's/\/.git//' -e 's/^.git$/./' \
            | sort
    done
}

command_constructor() {
    for directory in $1; do
        printf "\"git -P -C %s %s" \
            "$directory" "$options"
        printf " && printf '%b%b==>%b completed: %bgit%b %s %b%s%b\\\n'\"\n" \
            "$bold" "$green" "$reset" "$green" "$reset" "$options" "$cyan" \
            "$directory" "$reset"
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

command_constructor "$(git_directory "$@")" \
    | xargs -P"$procs" -I{} sh -c '{}'
