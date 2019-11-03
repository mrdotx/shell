#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/mount/sftp.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:25:08

# Connect to sftp via sshfs
# host must be in .ssh/known_hosts

# connection data {{{
DIR=$1
HOST=<Hostname>
USER=<Username>
PASS=<Password>
# }}}

sshfs -o password_stdin $USER@$HOST:/ "$DIR" <<< "$PASS" && exit 0
