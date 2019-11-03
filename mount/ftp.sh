#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/mount/ftp.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-03 17:24:32

# Connect to ftp via curlftpfs

# connection data {{{
DIR=$1
HOST=<Hostname>
USER=<Username>
PASS=<Password>
# }}}

curlftpfs $HOST "$DIR" -o user=$USER:$PASS && exit 0
