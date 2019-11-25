#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/mount/dropbox.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-25 13:16:54

rclonedir=$1
rclonehost=<rclonename>

# mount via rclone
rclone mount $rclonehost:/  $rclonedir &
