#!/bin/sh

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]
then
    echo "Pulling latest version"
    
    git pull origin dev

    echo "Incrementing version"

    CURRENT_CYCLE=$(cat cycle.txt)

    echo "Current: $CURRENT_CYCLE"

    CURRENT_CYCLE=$(($CURRENT_CYCLE + 1))

    echo "New cycle: $CURRENT_CYCLE"

    echo $CURRENT_CYCLE > cycle.txt
else
    echo "Skipping increment cycle. Cycle is only incremented in 'dev' branch not '$BRANCH' branch"
fi
