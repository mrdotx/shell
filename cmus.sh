#!/bin/sh

# path:       ~/projects/shell/cmus.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:53:14

# start cmus, if its running toggle from/to i3 scratchpad
if ! pgrep -x cmus ; then
    cmus
else
    i3-msg [title="cmus" instance="$TERMINAL"] scratchpad show
fi
