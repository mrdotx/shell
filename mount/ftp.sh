#!/bin/sh

# path:       ~/projects/shell/mount/ftp.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-12-21 14:47:54

ftpdir=$1
ftphost=<Hostname>
ftpuser=<Username>
ftppass=$(gpg -q --decrypt <passwordfile.gpg>)

# connect to ftp via curlftpfs
curlftpfs "$ftphost" "$ftpdir" -o user=$ftpuser:"$ftppass" && exit 0
