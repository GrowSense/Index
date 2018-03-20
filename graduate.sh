#!/bin/bash
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]
then
  echo "Graduating to master branch"

  # Checkout the master branch
  git checkout master && \

  # Ensure it's up to date
  git pull origin master && \

  # Merge the dev branch
  git merge dev && \

  # Push the updates
  git push origin master && \

  # Go back to the dev branch
  git checkout dev && \

  echo "The 'dev' branch has been graduated to the 'master' branch"  || \

  echo "Error"
else
  echo "You must be in the 'dev' branch to graduate to the 'master' branch."
fi
date
