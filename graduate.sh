#!/bin/bash

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ];  then
  bash pre-graduate.sh "master" || exit 1

  echo "Graduating dev branch to master branch"

  echo ""
  echo "  Fetching from origin..."
  git fetch origin || exit 1

#  # Pull the master branch into the dev branch
#  git pull origin master || exit 1

  echo ""
  echo "  Checking out the master branch..."
  git checkout master || exit 1

#  # Ensure it's up to date
#  git pull origin master --quiet && \

  echo ""
  echo "  Merging the dev branch into the master branch..."
  git merge -X theirs origin/dev || exit 1

  echo ""
  echo "  Pushing the updated master branch to origin..."
  git push origin master || exit 1

  echo ""
  echo "  Checking out the dev branch..."
  git checkout dev || exit 1

  echo "The 'dev' branch has been graduated to the 'master' branch"
else
  echo "You must be in the 'dev' branch to graduate to the 'master' branch, but currently in the '$BRANCH' branch. Skipping."
fi
