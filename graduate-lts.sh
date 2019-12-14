#!/bin/bash

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo "Graduating rc branch to lts branch..."

sh clean.sh || exit 1

echo ""
echo "Fetching from origin..."
git fetch origin || exit 1


if [ "$BRANCH" = "dev" ];  then
  echo "Currently in dev branch. Checking out rc branch..."
  git checkout rc || exit 1
fi

#echo ""
#echo "Pulling the rc branch from origin (to update it locally)..."
#git pull origin rc || exit 1

echo ""
echo "Merging the lts branch into the rc branch..."
git merge -X ours origin/lts || exit 1

echo ""
echo "Checking out the lts branch..."
git checkout lts || exit 1

#echo ""
#echo "Pulling the lts branch from origin (to update it locally)..."
#git pull origin lts || exit 1

echo ""
echo "Merging the rc branch into the lts branch..."
git merge -X theirs origin/rc || exit 1

echo ""
echo "Pushing the updated lts branch to origin..."
git push origin lts -q || exit 1

echo ""
echo "Checking out the $BRANCH branch again..."
git checkout $BRANCH || exit 1

echo ""
echo "The 'rc' branch has been graduated to the 'lts' branch"
