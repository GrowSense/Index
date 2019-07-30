#!/bin/bash

LOOP_NUMBER=$1

UPGRADE_FREQUENCY=$(cat supervisor-upgrade-frequency.txt)

if [ ! $LOOP_NUMBER ]; then
  LOOP_NUMBER=1
fi


echo ""
echo "Pulling device info from remote garden computers..."
sh pull-device-info-from-remotes.sh || echo "Failed to pull device info from remote garden computers"

echo ""
echo "Supervising docker services..."
sh supervise-docker.sh $LOOP_NUMBER || echo "Supervise docker failed"

echo ""
echo "Supervising devices..."
sh supervise-devices.sh $LOOP_NUMBER || echo "Supervise devices failed"


AUTO_UPGRADE_ENABLED=$(cat auto-upgrade-enabled.txt)

echo ""
echo "-----"
echo "Starting GreenSense Supervisor Loop: $LOOP_NUMBER"
echo ""
if [ "$AUTO_UPGRADE_ENABLED" = "1" ]; then
  if [ $(( $LOOP_NUMBER%$UPGRADE_FREQUENCY )) -eq "0" ]; then
    echo ""
    echo "  Initiating system upgrade..."
    bash upgrade-system.sh || exit 1
    echo ""
    echo "  Initiating device upgrades..."
    bash upgrade-garden-device-sketches.sh || exit 1 
  else
    echo "  Skipping upgrade this loop."
  fi
else
  echo "  Auto upgrade disabled. Skipping."
fi
echo ""
echo "Finished GreenSense Supervisor Loop: $LOOP_NUMBER"
echo "-----"
echo ""
