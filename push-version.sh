#!/bin/bash

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ];  then
  git commit buildnumber.txt -m "Updated build number [ci-skip]" && \
  git commit full-version.txt -m "Updated full version [ci-skip]" && \
  bash push.sh
#  git pull origin $BRANCH --quiet && \
#  git push origin $BRANCH --quiet
else
  echo "Skipping push version. Only pushed for 'dev' branch not '$BRANCH'"
fi
