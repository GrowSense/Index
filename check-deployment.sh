#!/bin/bash

echo "Checking status of deployment..."

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "lts" ]; then
  echo "LTS deployment on live garden..."
  INSTALL_HOST=$LTS_INSTALL_HOST
  INSTALL_SSH_USERNAME=$LTS_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$LTS_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$LTS_INSTALL_SSH_PORT
fi
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

[[ ! $(echo $PIO_LIST_RESULT) =~ "ttyUSB" ]] && echo "No USB devices are connected" && exit 1

echo "Viewing garden data..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index; sh view-garden.sh"

echo "Viewing garden status..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index; sh check-garden.sh"

echo "Viewing garden device versions..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index; sh check-garden-device-versions.sh"

# Only check the mosquitto service if the MQTT host is localhost (otherwise it's not installed because it's using a remote MQTT host)
MQTT_HOST=$(cat mqtt-host.security)
if [ "$MQTT_HOST" = "localhost" ] || [ "$MQTT_HOST" = "127.0.0.1" ]; then
  echo "Viewing mosquitto service status..."

  MOSQUITTO_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-mosquitto-docker.service")

  echo "${MOSQUITTO_RESULT}"

  [[ ! $(echo $MOSQUITTO_RESULT) =~ "Loaded: loaded" ]] && echo "Mosquitto service isn't loaded" && exit 1
  [[ ! $(echo $MOSQUITTO_RESULT) =~ "Active: active" ]] && echo "Mosquitto service isn't active" && exit 1
  [[ $(echo $MOSQUITTO_RESULT) =~ "not found" ]] && echo "Mosquitto service wasn't found" && exit 1
fi

echo "Viewing GreenSense Plug and Play service log..."

PNP_CONTROLLER_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u arduino-plug-and-play.service -b")

echo "${PNP_CONTROLLER_LOG}"

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

echo "Viewing GreenSense UI controller service log..."

UI_NAME="ui1"
if [ "$BRANCH" = "lts" ]; then
  UI_NAME="ui2"
fi
UI_CONTROLLER_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u greensense-ui-1602-$UI_NAME.service -b")

echo "${UI_CONTROLLER_LOG}"

echo "Viewing GreenSense UI controller service status..."

UI_CONTROLLER_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-ui-1602-$UI_NAME.service")

echo "${UI_CONTROLLER_RESULT}"

[[ ! $(echo $UI_CONTROLLER_RESULT) =~ "Loaded: loaded" ]] && echo "The UI controller service isn't loaded" && exit 1
[[ ! $(echo $UI_CONTROLLER_RESULT) =~ "Active: active" ]] && echo "The UI controller service isn't active" && exit 1
[[ $(echo $UI_CONTROLLER_RESULT) =~ "not found" ]] && echo "The UI controller service wasn't found" && exit 1

echo "Viewing irrigator MQTT bridge service status..."
IRRIGATOR_NAME="irrigator1"
if [ "$BRANCH" = "lts" ]; then
  IRRIGATOR_NAME="irrigator2"
fi
IRRIGATOR_MQTT_BRIDGE_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-mqtt-bridge-$IRRIGATOR_NAME.service")

echo "${IRRIGATOR_MQTT_BRIDGE_RESULT}"

[[ ! $(echo $IRRIGATOR_MQTT_BRIDGE_RESULT) =~ "Loaded: loaded" ]] && echo "The $IRRIGATOR_NAME MQTT bridge service isn't loaded" && exit 1
[[ ! $(echo $IRRIGATOR_MQTT_BRIDGE_RESULT) =~ "Active: active" ]] && echo "The $IRRIGATOR_NAME MQTT bridge service isn't active" && exit 1
[[ $(echo $IRRIGATOR_MQTT_BRIDGE_RESULT) =~ "not found" ]] && echo "The $IRRIGATOR_NAME MQTT bridge service wasn't found" && exit 1

echo "Viewing ventilator MQTT bridge service status..."
VENTILATOR_NAME="ventilator1"
if [ "$BRANCH" = "lts" ]; then
  VENTILATOR_NAME="ventilator2"
fi
VENTILATOR_MQTT_BRIDGE_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-mqtt-bridge-$VENTILATOR_NAME.service")

echo "${VENTILATOR_MQTT_BRIDGE_RESULT}"

[[ ! $(echo $VENTILATOR_MQTT_BRIDGE_RESULT) =~ "Loaded: loaded" ]] && echo "The $VENTILATOR_NAME MQTT bridge service isn't loaded" && exit 1
[[ ! $(echo $VENTILATOR_MQTT_BRIDGE_RESULT) =~ "Active: active" ]] && echo "The $VENTILATOR_NAME MQTT bridge service isn't active" && exit 1
[[ $(echo $VENTILATOR_MQTT_BRIDGE_RESULT) =~ "not found" ]] && echo "The $VENTILATOR_NAME MQTT bridge service wasn't found" && exit 1

echo "Viewing illuminator MQTT bridge service status..."
ILLUMINATOR_NAME="illuminator1"
if [ $BRANCH = "lts" ]; then
  ILLUMINATOR_NAME="illuminator2"
fi
ILLUMINATOR_MQTT_BRIDGE_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-mqtt-bridge-$ILLUMINATOR_NAME.service")

echo "${ILLUMINATOR_MQTT_BRIDGE_RESULT}"

[[ ! $(echo $ILLUMINATOR_MQTT_BRIDGE_RESULT) =~ "Loaded: loaded" ]] && echo "The $ILLUMINATOR_NAME MQTT bridge service isn't loaded" && exit 1
[[ ! $(echo $ILLUMINATOR_MQTT_BRIDGE_RESULT) =~ "Active: active" ]] && echo "The $ILLUMINATOR_NAME MQTT bridge service isn't active" && exit 1
[[ $(echo $ILLUMINATOR_MQTT_BRIDGE_RESULT) =~ "not found" ]] && echo "The $ILLUMINATOR_NAME MQTT bridge service wasn't found" && exit 1

echo "Pulling update log files..."

mkdir -p logs/updates

sshpass -p $INSTALL_SSH_PASSWORD scp $INSTALL_SSH_USERNAME@$INSTALL_HOST:/usr/local/GreenSense/Index/logs/updates/*.txt logs/updates/

echo "Checking update log files..."
for LOG_FILE in logs/updates/*.txt; do
  echo "Log file: $LOG_FILE"
  LOG_FILE_CONTENT=$(cat $LOG_FILE)
  
  [[ $(echo $LOG_FILE_CONTENT) =~ "failed" ]] && echo "Upgrade failed" && exit 1
  [[ $(echo $LOG_FILE_CONTENT) =~ "error" ]] && echo "Upgrade resulted in error" && exit 1
done



echo "Finished checking status of deployment."
