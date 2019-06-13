#!/bin/bash

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo "Graduating master branch to lts branch..."

sh clean.sh || exit 1

if [ "$BRANCH" = "dev" ];  then
  echo "Currently in dev branch. Checking out master branch..."
  git checkout master || exit 1
fi

echo ""
echo "Fetching from origin..."
git fetch origin || exit 1

echo ""
echo "Pulling the master branch from origin (to update it locally)..."
git pull origin master || exit 1

echo ""
echo "Merging the lts branch into the master branch..."
git merge lts || exit 1

echo ""
echo "Checking out the lts branch..."
git checkout lts || exit 1

echo ""
echo "Pulling the lts branch from origin (to update it locally)..."
git pull origin lts || exit 1

echo ""
echo "Merging the master branch into the lts branch..."
git merge master || exit 1

echo ""
echo "Pushing the updated lts branch to origin..."
git push origin lts || exit 1

echo ""
echo "Checking out the $BRANCH branch again..."
git checkout $BRANCH || exit 1

echo ""
echo "The 'master' branch has been graduated to the 'lts' branch"
