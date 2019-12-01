#!/bin/sh

# path:       ~/coding/shell/cmus.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 12:36:00

# start cmus, if its running toggle from/to i3 scratchpad
if ! pgrep -x cmus ; then
    cmus
else
    i3-msg [title="cmus" instance="$TERMINAL"] scratchpad show
fi
