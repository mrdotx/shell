#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/terminal_wrapper.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:34:13

# procedure {{{
if [ $# -eq 0 ]; then "${SHELL:-bash}"; else "$@"; fi
echo ""
echo "The command exited with status $?. Press Enter to close $TERMINAL."
read line
# }}}
