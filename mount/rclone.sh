#!/bin/sh

# path:       ~/projects/shell/mount/rclone.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:48:06

rclonedir=$1
rclonehost=<rclonename>

# mount via rclone
rclone mount $rclonehost:/  "$rclonedir" &
