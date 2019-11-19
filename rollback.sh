#!/bin/bash

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "lts" ]
then
  echo "Rolling back the lts branch to previous revision"

  echo "Reverting to previous revision"
  git reset --hard HEAD~1 || exit 1

  echo "Pushing back to origin/lts"
  git push --force origin lts || exit 1

  echo "The 'lts' branch has been rolled back"
else
  echo "You must be in the 'lts' branch to perform a rollback. The '$BRANCH' branch doesn't get rolled back automatically."
fi

