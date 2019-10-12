#!/bin/bash

LOOP_NUMBER=$1

UPGRADE_FREQUENCY=$(cat supervisor-upgrade-frequency.txt)

if [ ! $LOOP_NUMBER ]; then
  LOOP_NUMBER=1
fi


echo ""
echo "Pulling device info from remote garden computers..."
bash pull-device-info-from-remotes.sh || echo "Failed to pull device info from remote garden computers"


DOCKER_CHECK_FREQUENCY=$(cat supervisor-docker-check-frequency.txt)

if [ "$(( $LOOP_NUMBER%$DOCKER_CHECK_FREQUENCY ))" -eq "0" ]; then
  echo ""
  echo "Supervising docker services..."
  bash supervise-docker.sh $LOOP_NUMBER || echo "Supervise docker failed"
else
  echo "Skipping docker check this loop..."
fi

MQTT_CHECK_FREQUENCY=$(cat supervisor-mqtt-check-frequency.txt)

if [ "$(( $LOOP_NUMBER%$MQTT_CHECK_FREQUENCY ))" -eq "0" ]; then
  echo ""
  echo "Supervising MQTT broker..."
  bash supervise-mqtt.sh $LOOP_NUMBER || echo "Supervise MQTT failed"
else
  echo "Skipping MQTT check this loop..."
fi

echo ""
echo "Supervising devices..."
bash supervise-devices.sh $LOOP_NUMBER || echo "Supervise devices failed"


AUTO_UPGRADE_ENABLED=$(cat auto-upgrade-enabled.txt)

echo ""
echo "-----"
echo "Starting GrowSense Supervisor Loop: $LOOP_NUMBER"
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
echo "Finished GrowSense Supervisor Loop: $LOOP_NUMBER"
echo "-----"
echo ""
