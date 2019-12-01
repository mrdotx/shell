#!/bin/sh

# path:       ~/coding/shell/mount/rclone.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-01 15:14:50

rclonedir=$1
rclonehost=<rclonename>

# mount via rclone
rclone mount $rclonehost:/  "$rclonedir" &
