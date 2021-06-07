#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/gpg_edit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-06-07T08:40:36+0200

password_store="${PASSWORD_STORE_DIR-$HOME/.password-store}"

if printf "%s" "$(pwd)" | grep -q "^$password_store"; then
    path="$(printf "%s/\n" "$1" \
            | sed -e "s#$password_store/##" -e "s#\.gpg##")"
    pass edit "$path"
else
    $EDITOR "$1"
fi
