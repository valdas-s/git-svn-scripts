#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <repository name> <local dir>"
  exit 1
fi

# Import 
git svn clone "$1" --authors-file="./users.txt" --no-metadata -s "$2"

# Post Processing
cd "$2"
git gc

# Create Branches
for b in $(git branch -r | grep -v 'tags/' | grep -v 'trunk'); do
  git checkout $b
  git checkout -b $b
done
git checkout master

# Create Tags
for t in $(git branch -r | grep 'tags/' | cut -d '/' -f 2); do
  git checkout "tags/$t"
  git tag $t
done
git checkout master

echo
echo "Tag list:"
git tag
echo "Branch list:"
git branch

echo "Check if all tags and branches were migrated, and if so push to GIT by executing the following:"
echo git remote add origin "git@my-git-server:/some/path/$2.git"
echo git push origin --all

cd ..