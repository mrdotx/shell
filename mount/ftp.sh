#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/mount/ftp.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-09 22:06:31

# connect to ftp via curlftpfs
ftpdir=$1
ftphost=<Hostname>
ftpuser=<Username>
ftppass=$(gpg -q --decrypt <passwordfile.gpg>)

curlftpfs $ftphost "$ftpdir" -o user=$ftpuser:$ftppass && exit 0
