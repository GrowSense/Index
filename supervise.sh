#!/bin/bash

LOOP_NUMBER=$1

UPGRADE_MOD_VALUE=100

if [ ! $LOOP_NUMBER ]; then
  LOOP_NUMBER=1
fi

echo ""
echo "-----"
echo "Starting GreenSense Supervisor Loop: $LOOP_NUMBER"
echo ""
if [ $(( $LOOP_NUMBER%$UPGRADE_MOD_VALUE )) -eq "0" ]; then
  echo ""
  echo "  Initiating upgrade."
  sh upgrade.sh || exit 1
else
  echo "  Skipping upgrade this loop."
fi

echo ""
echo "Supervising devices..."
sh supervise-devices.sh || exit 1

echo ""
echo "Finished GreenSense Supervisor Loop: $LOOP_NUMBER"
echo "-----"
echo ""
