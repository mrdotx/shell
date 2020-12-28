#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/git_multi.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-12-28T22:49:37+0100

config="
    $HOME/.local/share/repos
"
options="${*:-status}"

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
            && printf ":: git $options \"%s\"\n" "$line" \
            && cd "$line" \
            && eval git "$options"
    done
}
