#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/mount/sftp.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# Connect to sftp via sshfs
# host must be in .ssh/known_hosts

# connection data {{{
DIR=$1
HOST=<Hostname>
USER=<Username>
PASS=<Password>
# }}}

sshfs -o password_stdin $USER@$HOST:/ "$DIR" <<< "$PASS" && exit 0
