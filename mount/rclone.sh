#!/bin/sh

# path:       ~/projects/shell/mount/rclone.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-02 00:32:44

rclonedir=$1
rclonehost=<rclonename>

# mount via rclone
rclone mount $rclonehost:/ "$rclonedir" &
