#!/bin/bash

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ];  then
  git checkout master || exit 1
fi

echo "Graduating master branch to lts branch"

# Fetch other branches
git fetch origin --quiet && \

# Pull the lts branch into the master branch
git pull origin lts --quiet && \

# Checkout the lts branch
git checkout lts && \

# Ensure it's up to date
git pull origin lts --quiet && \

# Merge the master branch
git merge -q master && \

# Push the updates
git push origin lts --quiet && \

# Go back to the original branch
git checkout $BRANCH && \

echo "The 'master' branch has been graduated to the 'lts' branch"
