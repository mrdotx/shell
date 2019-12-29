#!/bin/sh

# path:       ~/projects/shell/cmus.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-29 19:54:15

# start cmus, if its running toggle from/to i3 scratchpad
if ! pgrep -x cmus ; then
    cmus && polybar-msg hook module/cmus 1
else
    i3-msg [title="cmus" instance="$TERMINAL"] scratchpad show
fi
