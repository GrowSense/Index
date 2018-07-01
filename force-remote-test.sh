#!/bin/bash

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]
then
  echo "Forcing remote test"

  echo " " >> Jenkinsfile.hw
  
  git pull origin dev && \
  git commit Jenkinsfile.hw -m "Forcing retest" && \
  git push origin dev && \
  
  echo "Repository has been updated. Test should now start on test server."
else
  echo "Cannot force retest from master branch. Switch to dev branch first."
fi
