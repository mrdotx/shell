#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/suspend.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# procedure {{{
# logout
# blurlock
# logout and suspend
i3exit lock && i3exit suspend
# }}}
