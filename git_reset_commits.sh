#!/bin/sh

# path:   /home/klassiker/.local/share/repos/shell/git_reset_commits.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/shell
# date:   2021-01-15T13:59:06+0100

printf ":: github\n checkout...\n"
git checkout --orphan latest_branch

printf " add all the files and folders...\n"
git add -A

printf " commit the changes...\n"
git commit -am "reset commits"

printf " delete the branch...\n"
git branch -D master

printf " rename the current branch to master...\n"
git branch -m master

printf " force update repository...\n"
git push -f origin master

printf " set upstream...\n"
git push --set-upstream origin master
