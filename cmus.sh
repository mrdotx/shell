#!/bin/sh
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/cmus.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-12 12:50:55

# start cmus, if its running toggle pause/play 
if ! pgrep -x cmus ; then
    cmus
else
    cmus-remote -u
fi
