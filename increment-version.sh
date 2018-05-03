#!/bin/sh

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]
then
    echo "Incrementing version"

    CURRENT_VERSION=$(cat buildnumber.txt)

    echo "Current: $CURRENT_VERSION"

    CURRENT_VERSION=$(($CURRENT_VERSION + 1))

    echo "New version: $CURRENT_VERSION"

    echo $CURRENT_VERSION > buildnumber.txt
else
    echo "Skipping increment version. Version is only incremented in 'dev' branch not '$BRANCH' branch"
fi