#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/git_fetch.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-12-28T21:43:42+0100

config="
    $HOME/.local/share/repos
"

folder() {
    printf "%s\n" "$config" | {
        while IFS= read -r line; do
            [ -n "$line" ] \
                && line=$(printf "%s/*/.git" "$line" \
                    | sed 's/ //g') \
                && locate "$line"
        done
    }
}

printf "%s\n" "$(folder)" | {
    while IFS= read -r line; do
        [ -n "$line" ] \
            && line=$(printf "%s" "$line" \
                | sed 's/ //g;s/\/.git//') \
            && printf ":: git fetch \"%s\"\n" "$line" \
            && cd "$line" \
            && git fetch origin
    done
}
