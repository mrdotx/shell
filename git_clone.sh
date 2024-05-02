#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/git_clone.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-05-01T09:11:15+0200

# config
cn="users"
name="mrdotx"
procs=$(($(nproc --all) * 4))

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to clone all repositories of a user or organization
  Usage:
    $script [cn] [name] [procs]

  Settings:
    [cn]    = must be users or orgs (default=$cn)
    [name]  = must be a username or organisation (default=$name)
    [procs] = processes to parallel download the repositories (default=$procs)

  Examples:
    $script
    $script $cn $name
    $script $cn $name $procs"

case $1 in
    -h | --help)
        printf "%s\n" "$help"
        exit 0
        ;;
    *)
        curl -fsS "https://api.github.com/${1-$cn}/${2-$name}/repos?per_page=1000" \
            | grep 'git_url' \
            | cut -d "\"" -f 4 \
            | xargs -P"${3-$procs}" -L1 git clone
esac
