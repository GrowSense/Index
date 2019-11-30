#!/bin/bash

LOOP_NUMBER=$1

if [ ! $LOOP_NUMBER ]; then
  LOOP_NUMBER=0
fi

echo ""
echo "Pulling device info from remote garden computers..."
bash pull-device-info-from-remotes.sh || echo "Failed to pull device info from remote garden computers"

echo ""
echo "Pulling messages remote garden computers..."
bash pull-messages-from-remotes.sh || echo "Failed to pull messages from remote garden computers"

echo ""
echo "Finished GrowSense mesh manager loop: $LOOP_NUMBER"
echo "-----"
echo ""
