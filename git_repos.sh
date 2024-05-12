#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/git_repos.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2024-05-12T08:48:03+0200

# config
name="mrdotx"
cn="users"

# help
script=$(basename "$0")
help="$script [-h/--help] -- script to perform operations for all repositories
                            of a user or organization
  Usage:
    $script [-c/--clone] [-i/--infos] [-j/--json] [name] [cn]

  Settings:
    [-c/--clone] = clone all repositories of a user or organization
    [-i/--infos] = show count of repos/stargazers/forks of a user or organisation
    [-j/--json]  = outputs the raw json data of repos
    [name]       = must be a username or organisation (default=$name)
    [cn]         = must be users or orgs (default=$cn)

  Examples:
    $script --clone
    $script --clone $name
    $script -c $name $cn
    $script --infos
    $script -i $name
    $script --infos $name $cn
    $script -j
    $script -j $name
    $script --json $name $cn"

# functions
get_repos() {
    curl -fsS \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/$2/$1/repos?per_page=1000"
}

get_values() {
    printf "%s" "$1" \
        | awk -F "$2" 'NF > 1 {print $2}' \
        | sed "s/$3//"
}

count_values() {
    values="$(get_values "$1" "$2" "$3")"
    for value in $values; do
        count=$((count+value))
    done

    printf "%s" "$count"
}

# main
case $1 in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -c | --clone)
        shift
        repos=$(get_repos "${1:-$name}" "${2:-$cn}")

        procs="$(($(nproc --all) * 4))"
        get_values "$repos" '"clone_url": "' '",' \
            | xargs -P"$procs" -L1 git clone
        ;;
    -i | --infos)
        shift
        repos=$(get_repos "${1:-$name}" "${2:-$cn}")

        repos_count=$( \
            get_values "$repos" '"full_name": "' '",' \
                | wc -l \
        )

        stars_count="$(count_values "$repos" '"stargazers_count": ' ',')"

        forks_count="$(count_values "$repos" '"forks_count": ' ',')"

        printf "%s |  %d  %d  %d\n" \
            "${1:-$name}" \
            "$repos_count" \
            "$stars_count" \
            "$forks_count"
        ;;
    -j | --json)
        shift
        get_repos "${1:-$name}" "${2:-$cn}"
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac
