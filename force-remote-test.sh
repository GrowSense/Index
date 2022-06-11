#!/bin/bash

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]
then
  echo "Forcing remote test"

  bash clean.sh
  
  echo " " >> .gitlab-ci.yml
  
  bash pull.sh && \
  bash increment-version.sh && \

  git commit .gitlab-ci.yml full-version.txt buildnumber.txt -m "Forcing retest" && \
  bash push.sh || exit 1
  
  echo "Repository has been updated. Test should now start on test server."
else
  echo "Cannot force retest from master branch. Switch to dev branch first."
fi
