#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/wlan.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:34:24

# procedure {{{
# Connect to WLAN
nmcli device wifi list && nmtui
# }}}
