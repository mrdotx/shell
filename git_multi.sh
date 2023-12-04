#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/git_multi.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-11-28T09:49:40+0100

# config
default="status"
procs=$(nproc)

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
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    reset=$(tput sgr0)

    for folder in $1; do
        repo_folder="${folder%/*}"
        repo="${repo_folder##*/}/${folder##*/}"
        footer="printf '  -> completed: ${green}git $options $yellow$repo$reset\n'" \
            && printf "\"output=\$(cd $folder && git $options && %s)\"\n" \
                "$footer"
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
     | xargs -P"$procs" -I{} sh -c "{} && printf \"%s\n\" \"\$output\""
