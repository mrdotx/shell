#!/bin/bash
# vim:fileencoding=utf-8:ft=sh:foldmethod=marker

# path:       ~/coding/shell/mount/sftp.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2019-11-09 22:08:37

# connect to sftp via sshfs
# host must be in .ssh/known_hosts
sftpdir=$1
sftphost=<Hostname>
sftpuser=<Username>
sftppass=$(gpg -q --decrypt <passwordfile.gpg>)

sshfs -o password_stdin $sftpuser@$sftphost:/ "$sftpdir" <<< "$sftppass" && exit 0
