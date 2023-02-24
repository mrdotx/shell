#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/system_cleanup.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2023-02-24T19:30:20+0100

# config
iwd_history="$HOME/.local/share/iwctl/history"
cmd_history="$HOME/.local/share/cmd_history" # combined zsh and bash history
cache_directory="$HOME/.cache/"
cache_days=365

# helper
find_files() {
    find "$cache_directory" \
        -type f \
        -mtime +"$cache_days" \
        -not -path "*/paru/*" \
        "$@"
}

history_clean() {
    printf "%s %s %s\n %s\n" \
        ":: purge" \
        "$1" \
        "history" \
        "remove white space from the end of the line..."
    sed -i 's/ *$//' "$2"
    printf " remove duplicates...\n"
    printf "%s\n" "$(tac "$2" \
        | awk '! seen[$0]++' \
        | tac \
    )" > "$2"
}

cache_clean() {
    cache_files=$(find_files \
        | wc -l \
    )

    printf "\n%s\n %s %s %d %s\n" \
        ":: delete files from .cache folder" \
        "$cache_files" \
        "files that haven't been accessed in" \
        "$cache_days" \
        "days..."

    if [ "$cache_files" -gt 0 ]; then
        find_files
        key=""
        printf "\n\r delete files from .cache folder [y]es/[N]o: " \
            && read -r "key"
        case "$key" in
            y|Y|yes|Yes)
                find_files -delete
                exit 0
                ;;
            *)
                exit 0
                ;;
        esac
    else
        exit 0
    fi
}

# main
history_clean "iwctl" "$iwd_history"
printf "\n"
history_clean "merged zsh and bash" "$cmd_history"
cache_clean
