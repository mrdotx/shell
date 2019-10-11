#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/terminal_wrapper.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# procedure {{{
if [ $# -eq 0 ]; then "${SHELL:-bash}"; else "$@"; fi
echo ""
echo "The command exited with status $?. Press Enter to close $TERMINAL."
read line
# }}}
