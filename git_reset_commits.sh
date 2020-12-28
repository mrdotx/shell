#!/bin/sh

# path:       /home/klassiker/.local/share/repos/shell/delete_github_commits.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-05-14T13:41:11+0200

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
