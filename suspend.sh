#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/suspend.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:34:07

# procedure {{{
# logout
# blurlock
# logout and suspend
i3exit lock && i3exit suspend
# }}}
