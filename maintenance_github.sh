#!/bin/sh

# path:       ~/projects/shell/maintenance_github.sh
# user:       klassiker [mrdotx]
# github:     https://github.com/mrdotx/shell
# date:       2020-01-19T10:46:22+0100

echo "github"
echo "  1. checkout"
git checkout --orphan latest_branch

echo "  2. add all the files and folders"
git add -A

echo "  3. commit the changes"
git commit -am "reset commits"

echo "  4. delete the branch"
git branch -D master

echo "  5. rename the current branch to master"
git branch -m master

echo "  6. force update repository"
git push -f origin master

echo "  7. set upstream"
git push --set-upstream origin master
