#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/gpg_edit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-06-05T17:38:08+0200

edit="$EDITOR"
working_directory="$(pwd)"

if [ -z "$PASSWORD_STORE_DIR" ]; then
    password_store="$HOME/.password_store"
else
    password_store="$PASSWORD_STORE_DIR"
fi

if printf "%s" "$working_directory" | grep -q "^$password_store"; then
    path="$(printf "%s/\n" "$1" \
            | sed -e "s#$password_store/##" -e "s#\.gpg##")"

    pass edit "$path"
else
    $edit "$1"
fi
