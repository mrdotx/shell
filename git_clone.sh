#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/git_clone.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-07-02T09:26:04+0200

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to clone all repositories of a user or organization
  Usage:
    $script [cn] [name] [page]

  Settings:
    [cn]   = must be users or orgs (default=users)
    [name] = must be a username or organisation (default=mrdotx)
    [page] = page number to download (default=1)
             the maximum page-size is 100 repositories per page

  Examples:
    $script
    $script users mrdotx 1"

case $1 in
    -h | --help)
        printf "%s\n" "$help"
        exit 0
        ;;
    *)
        curl -s "https://api.github.com/${1-users}/${2-mrdotx}/repos?page=${3-1}&per_page=100" \
            | grep 'git_url' \
            | cut -d "\"" -f 4 \
            | xargs -L1 git clone
esac
