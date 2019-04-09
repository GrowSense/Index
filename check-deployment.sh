#!/bin/bash

echo "Checking status of deployment..."

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "master" ]; then
  echo "Master deployment on live garden..."
  INSTALL_HOST=$MASTER_INSTALL_HOST
  INSTALL_SSH_USERNAME=$MASTER_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$MASTER_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$MASTER_INSTALL_SSH_PORT
fi
if [ "$BRANCH" = "dev" ]; then
  echo "Dev deployment on staging garden..."
  INSTALL_HOST=$DEV_INSTALL_HOST
  INSTALL_SSH_USERNAME=$DEV_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$DEV_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$DEV_INSTALL_SSH_PORT
fi

echo "Host: $INSTALL_HOST"

echo "Viewing platform.io list..."

PIO_LIST_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "pio device list")

echo "${PIO_LIST_RESULT}"

[[ ! $(echo $PIO_LIST_RESULT) =~ "ttyUSB2" ]] && echo "Not all USB devices are connected" && exit 1

echo "Viewing arduino plug and play service status..."

PNP_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status arduino-plug-and-play.service")

echo "${PNP_RESULT}"

[[ ! $(echo $PNP_RESULT) =~ "Loaded: loaded" ]] && echo "Arduino Plug and Play service isn't loaded" && exit 1
[[ ! $(echo $PNP_RESULT) =~ "Active: active" ]] && echo "Arduino Plug and Play service isn't active" && exit 1
[[ $(echo $PNP_RESULT) =~ "not found" ]] && echo "Arduino Plug and Play service wasn't found" && exit 1

echo "Viewing GreenSense supervisor service status..."

SUPERVISOR_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-supervisor.service")

echo "${SUPERVISOR_RESULT}"

[[ ! $(echo $SUPERVISOR_RESULT) =~ "Loaded: loaded" ]] && echo "GreenSense supervisor service isn't loaded" && exit 1
[[ ! $(echo $SUPERVISOR_RESULT) =~ "Active: active" ]] && echo "GreenSense supervisor service isn't active" && exit 1
[[ $(echo $SUPERVISOR_RESULT) =~ "not found" ]] && echo "GreenSense supervisor service wasn't found" && exit 1

echo "Viewing GreenSense UI controller service status..."

UI_CONTROLLER_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-ui-1602-ui1.service")

echo "${UI_CONTROLLER_RESULT}"

[[ ! $(echo $UI_CONTROLLER_RESULT) =~ "Loaded: loaded" ]] && echo "The UI controller service isn't loaded" && exit 1
[[ ! $(echo $UI_CONTROLLER_RESULT) =~ "Active: active" ]] && echo "The UI controller service isn't active" && exit 1
[[ $(echo $UI_CONTROLLER_RESULT) =~ "not found" ]] && echo "The UI controller service wasn't found" && exit 1

echo "Viewing irrigator1 MQTT bridge service status..."

IRRIGATOR_MQTT_BRIDGE_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-mqtt-bridge-irrigator1.service")

echo "${IRRIGATOR_MQTT_BRIDGE_RESULT}"

[[ ! $(echo $IRRIGATOR_MQTT_BRIDGE_RESULT) =~ "Loaded: loaded" ]] && echo "The irrigator1 MQTT bridge service isn't loaded" && exit 1
[[ ! $(echo $IRRIGATOR_MQTT_BRIDGE_RESULT) =~ "Active: active" ]] && echo "The irrigator1 MQTT bridge service isn't active" && exit 1
[[ $(echo $IRRIGATOR_MQTT_BRIDGE_RESULT) =~ "not found" ]] && echo "The irrigator1 MQTT bridge service wasn't found" && exit 1

echo "Viewing ventilator1 MQTT bridge service status..."

VENTILATOR_MQTT_BRIDGE_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-mqtt-bridge-ventilator1.service")

echo "${VENTILATOR_MQTT_BRIDGE_RESULT}"

[[ ! $(echo $VENTILATOR_MQTT_BRIDGE_RESULT) =~ "Loaded: loaded" ]] && echo "The ventilator1 MQTT bridge service isn't loaded" && exit 1
[[ ! $(echo $VENTILATOR_MQTT_BRIDGE_RESULT) =~ "Active: active" ]] && echo "The ventilator1 MQTT bridge service isn't active" && exit 1
[[ $(echo $VENTILATOR_MQTT_BRIDGE_RESULT) =~ "not found" ]] && echo "The ventilator1 MQTT bridge service wasn't found" && exit 1

#echo "Viewing illuminator1 MQTT bridge service status..."

#ILLUMINATOR_MQTT_BRIDGE_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-mqtt-bridge-illuminator1.service" || (echo "Error attempting to view irrigator1 MQTT bridge status." && exit 1))

#echo "${ILLUMINATOR_MQTT_BRIDGE_RESULT}"

#[[ ! $(echo $ILLUMINATOR_MQTT_BRIDGE_RESULT) =~ "Loaded: loaded" ]] && echo "The illuminator1 MQTT bridge service isn't loaded" && exit 1
#[[ ! $(echo $ILLUMINATOR_MQTT_BRIDGE_RESULT) =~ "Active: active" ]] && echo "The illuminator1 MQTT bridge service isn't active" && exit 1
#[[ $(echo $ILLUMINATOR_MQTT_BRIDGE_RESULT) =~ "not found" ]] && echo "The illuminator1 MQTT bridge service wasn't found" && exit 1

echo "Viewing garden data..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index; sh view-garden.sh"

echo "Viewing garden status..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index; sh check-garden.sh"

echo "Viewing garden device versions..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index; sh check-garden-device-versions.sh"

echo "Pulling update log files..."

mkdir -p logs/updates

sshpass -p $INSTALL_SSH_PASSWORD scp $INSTALL_SSH_USERNAME@$INSTALL_HOST:/usr/local/GreenSense/Index/logs/updates/*.txt logs/updates/

for LOG_FILE in logs/updates/*.txt; do
  echo "Log file: $LOG_FILE"
  LOG_FILE_CONTENT=$(cat $LOG_FILE)
  
  [[ $(echo $LOG_FILE_CONTENT) =~ "failed" ]] && echo "Upgrade failed" && exit 1
  [[ $(echo $LOG_FILE_CONTENT) =~ "error" ]] && echo "Upgrade resulted in error" && exit 1
done



echo "Finished checking status of deployment."
