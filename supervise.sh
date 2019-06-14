#!/bin/bash

LOOP_NUMBER=$1

UPGRADE_MOD_VALUE=100

if [ ! $LOOP_NUMBER ]; then
  LOOP_NUMBER=1
fi

AUTO_UPGRADE_ENABLED=$(cat auto-upgrade-enabled.txt)

echo ""
echo "-----"
echo "Starting GreenSense Supervisor Loop: $LOOP_NUMBER"
echo ""
if [ "$AUTO_UPGRADE_ENABLED" = "1" ]; then
  if [ $(( $LOOP_NUMBER%$UPGRADE_MOD_VALUE )) -eq "0" ]; then
    echo ""
    echo "  Initiating upgrade."
    sh upgrade.sh || exit 1
  else
    echo "  Skipping upgrade this loop."
  fi
else
  echo "  Auto upgrade disabled. Skipping."
fi

echo ""
echo "Pulling device info from remote garden computers..."
sh pull-device-info-from-remotes.sh || echo "Failed to pull device info from remote garden computers"

echo ""
echo "Supervising devices..."
sh supervise-devices.sh || echo "Supervise devices failed"

echo ""
echo "Finished GreenSense Supervisor Loop: $LOOP_NUMBER"
echo "-----"
echo ""
