#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/terminal_wrapper.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-30 18:45:31

# execute command in new terminal window
if [ $# -eq 0 ]; then "${SHELL:-bash}"; else "$@"; fi
echo; echo "The command exited with status $?."

# wait for keypress
while true; do
    read -sn1 -p "Press [q]uit or [c]lose to exit this window..." keypress; echo
    case "$keypress" in
        Q|q|C|c) exit 0
    esac
done
