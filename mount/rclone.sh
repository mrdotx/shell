#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/mount/rclone.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-28 21:53:44

rclonedir=$1
rclonehost=<rclonename>

# mount via rclone
rclone mount $rclonehost:/  $rclonedir &
