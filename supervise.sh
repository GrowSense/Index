#!/bin/bash

LOOP_NUMBER=$1

UPGRADE_MOD_VALUE=100

if [ ! $LOOP_NUMBER ]; then
  LOOP_NUMBER=1
fi

echo "-----"
echo "GreenSense Supervisor Loop: $LOOP_NUMBER"

if [ $(( $LOOP_NUMBER%$UPGRADE_MOD_VALUE )) -eq "0" ]; then
  echo "  Initiating upgrade."
  sh upgrade.sh || (echo "Upgrade failed." && exit 1)
else
  echo "  Skipping upgrade this loop."
fi

sh supervise-devices.sh || (echo "Supervise garden devices failed." && exit 1)

echo "Finished GreenSense Supervisor Loop: $LOOP_NUMBER"
echo "-----"
