#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/system_cleanup.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-10-20T19:51:57+0200

iwd_history="$HOME/.local/share/iwctl/history"
cmd_history="$HOME/.local/share/cmd_history" # zsh and bash history merged
cache_directory="$HOME/.cache/"
cache_days=365
cache_files=$(find "$cache_directory" -type f -atime +$cache_days \
    | wc -l \
)

history_clean() {
    printf ":: purge %s history\n remove white space from the end of the line...\n" "$1"
    sed -i 's/ *$//' "$2"
    printf " remove duplicates...\n"
    printf "%s\n" "$(tac "$2" \
        | awk '! seen[$0]++' \
        | tac \
    )" > "$2"
}

cache_clean() {
    printf "\n:: delete files from .cache folder\n %s files that haven't been accessed in %d days...\n" "$cache_files" "$cache_days"

    if [ "$cache_files" -gt 0 ]; then
        find "$cache_directory" -type f -atime +$cache_days

        key=""
        while true; do
            printf "\n\r%s" " delete files from .cache folder [y]es/[N]o: " && read -r "key"
            case "$key" in
                y|Y|yes|Yes)
                    find "$cache_directory" -type f -atime +$cache_days -delete
                    ;;
                *)
                    exit 0
                    ;;
            esac
        done
    else
        exit 0
    fi
}

history_clean "iwctl" "$iwd_history"
printf "\n"
history_clean "merged zsh and bash" "$cmd_history"
cache_clean
