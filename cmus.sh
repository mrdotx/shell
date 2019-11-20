#!/bin/sh
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/cmus.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-20 13:38:46

# start cmus, if its running toggle from/to i3 scratchpad
if ! pgrep -x cmus ; then
    cmus
else
    i3-msg [instance=$TERMINAL title=cmus] scratchpad show
fi
