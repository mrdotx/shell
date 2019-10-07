#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# Path:     ~/coding/shell/mount/ftp.sh
# User:     klassiker [mrdotx]
# GitHub:   https://github.com/mrdotx/shell

# Connect to ftp via curlftpfs

# connection data {{{
DIR=$1
HOST=<Hostname>
USER=<Username>
PASS=<Password>
# }}}

curlftpfs $HOST "$DIR" -o user=$USER:$PASS && exit 0
