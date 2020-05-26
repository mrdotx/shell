#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/system_cleanup.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-26T12:41:24+0200

iw_hist="$HOME/.local/share/iwctl/history"
cmd_hist="$HOME/.local/share/cmd_history" # zsh and bash history merged
cache_dir="$HOME/.cache/"
cache_days=120
cache_files=$(find "$cache_dir" -type f -atime +$cache_days \
    | wc -l \
)
tmp_file=$(mktemp /tmp/history.XXXXXX)

hist_clean(){
    printf ":: purge %s history\n remove white space from the end of the line...\n" "$1"
    sed -i "s/ *$//" "$2"
    printf " remove duplicates...\n"
}

cache_header(){
    printf "\n:: delete .cache files\n %s files that haven't been accessed in %d days...\n" "$cache_files" "$cache_days"
}

cache_clean(){
    cache_header
    find "$cache_dir" -type f -atime +$cache_days

    key=""
    while true; do
        printf "\n\r%s" " delete .cache files [y]es/[N]o: " && read -r "key"
        case "$key" in
            y|Y|yes|Yes)
                find "$cache_dir" -type f -atime +$cache_days -delete \
                    && exit 0
                ;;
            *)
                exit 0
                ;;
        esac
    done
}

hist_clean "iwctl" "$iw_hist"
tac "$iw_hist" | awk '! seen[$0]++' | tac > "$tmp_file"
cp "$tmp_file" "$iw_hist"

printf "\n"
hist_clean "merged zsh and bash" "$cmd_hist"
tac "$cmd_hist" | awk '! seen[$0]++' | tac > "$tmp_file"
mv "$tmp_file" "$cmd_hist"

if [ "$cache_files" -gt 0 ]; then
    cache_clean
else
    cache_header
    exit 0
fi
