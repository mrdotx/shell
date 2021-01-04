#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/git_multi.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2021-01-04T20:44:13+0100

# config
default="status"

# color variables
green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

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
config="$(printf "%s" "${*:-$(pwd)}" \
    | sed 's/ /\n/g' \
)"

folder() {
    printf "%s\n" "$config" | {
        while IFS= read -r line; do
            [ -n "$line" ] \
                && find "$line" -maxdepth 2 -type d -name ".git" |
                    sort
        done
    }
}

printf "%s\n" "$(folder)" | {
    while IFS= read -r line; do
        [ -n "$line" ] \
            && line=$(printf "%s" "$line" \
                | sed 's/\/.git//') \
            && printf ":: %sgit %s %s\"%s\"%s\n" \
                "$green" \
                "$options" \
                "$yellow" \
                "$line" \
                "$reset" \
            && cd "$line" \
            && eval git "$options"
    done
}
