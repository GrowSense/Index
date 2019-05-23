#!/bin/bash

echo ""
echo "Checking status of deployment..."
echo ""

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "lts" ]; then
  echo "LTS deployment on live garden..."
  INSTALL_HOST=$LTS_INSTALL_HOST
  INSTALL_SSH_USERNAME=$LTS_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$LTS_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$LTS_INSTALL_SSH_PORT
  INSTALL_MQTT_HOST=$LTS_MQTT_HOST
fi
if [ "$BRANCH" = "master" ]; then
  echo "Master deployment on live garden..."
  INSTALL_HOST=$MASTER_INSTALL_HOST
  INSTALL_SSH_USERNAME=$MASTER_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$MASTER_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$MASTER_INSTALL_SSH_PORT
  INSTALL_MQTT_HOST=$MASTER_MQTT_HOST
fi
if [ "$BRANCH" = "dev" ]; then
  echo "Dev deployment on staging garden..."
  INSTALL_HOST=$DEV_INSTALL_HOST
  INSTALL_SSH_USERNAME=$DEV_INSTALL_SSH_USERNAME
  INSTALL_SSH_PASSWORD=$DEV_INSTALL_SSH_PASSWORD
  INSTALL_SSH_PORT=$DEV_INSTALL_SSH_PORT
  INSTALL_MQTT_HOST=$DEV_MQTT_HOST
fi

echo "Host: $INSTALL_HOST"

echo ""
echo "Viewing platform.io list..."

PIO_LIST_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "pio device list")

echo "${PIO_LIST_RESULT}"

[[ ! $(echo $PIO_LIST_RESULT) =~ "ttyUSB" ]] && echo "No USB devices are connected" && exit 1

echo ""
echo "Viewing mosquitto service status..."
echo "  MQTT Host: $INSTALL_MQTT_HOST"

# Only check the mosquitto service if the MQTT host is localhost (otherwise it's not installed because it's using a remote MQTT host)
if [ "$INSTALL_MQTT_HOST" = "localhost" ] || [ "$INSTALL_MQTT_HOST" = "127.0.0.1" ]; then
  echo "MQTT host is running on the local host"
  MOSQUITTO_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-mosquitto-docker.service")

  echo "${MOSQUITTO_RESULT}"

  [[ ! $(echo $MOSQUITTO_RESULT) =~ "Loaded: loaded" ]] && echo "Mosquitto service isn't loaded" && exit 1
  [[ ! $(echo $MOSQUITTO_RESULT) =~ "Active: active" ]] && echo "Mosquitto service isn't active" && exit 1
  [[ $(echo $MOSQUITTO_RESULT) =~ "not found" ]] && echo "Mosquitto service wasn't found" && exit 1
else
  echo "Skipping mosquitto service status check. Mosquitto service hasn't been installed because the MQTT host is on another server: $INSTALL_MQTT_HOST"
fi

echo ""
echo "Viewing GreenSense Plug and Play service log..."

PNP_CONTROLLER_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u arduino-plug-and-play.service -b")

echo "${PNP_CONTROLLER_LOG}"

echo ""
echo "Viewing arduino plug and play service status..."

PNP_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status arduino-plug-and-play.service")

echo "${PNP_RESULT}"

[[ ! $(echo $PNP_RESULT) =~ "Loaded: loaded" ]] && echo "Arduino Plug and Play service isn't loaded" && exit 1
[[ ! $(echo $PNP_RESULT) =~ "Active: active" ]] && echo "Arduino Plug and Play service isn't active" && exit 1
[[ $(echo $PNP_RESULT) =~ "not found" ]] && echo "Arduino Plug and Play service wasn't found" && exit 1

echo ""
echo "Identifying UI device name..."

UI_NAME="ui1"
if [ "$BRANCH" = "lts" ]; then
  UI_NAME="ui2"
fi
echo "  UI device name: $UI_NAME"

echo ""
echo "Viewing GreenSense UI controller service log..."

UI_CONTROLLER_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u greensense-ui-1602-$UI_NAME.service -b")

echo "${UI_CONTROLLER_LOG}"

echo ""
echo "Viewing GreenSense UI controller service status..."

UI_CONTROLLER_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-ui-1602-$UI_NAME.service")

echo "${UI_CONTROLLER_RESULT}"

[[ ! $(echo $UI_CONTROLLER_RESULT) =~ "Loaded: loaded" ]] && echo "The UI controller service isn't loaded" && exit 1
[[ ! $(echo $UI_CONTROLLER_RESULT) =~ "Active: active" ]] && echo "The UI controller service isn't active" && exit 1
[[ $(echo $UI_CONTROLLER_RESULT) =~ "not found" ]] && echo "The UI controller service wasn't found" && exit 1

echo ""
echo "Identifying irrigator name..."
IRRIGATOR_NAME="irrigator1"
if [ "$BRANCH" = "lts" ]; then
  IRRIGATOR_NAME="irrigator2"
fi
echo "  Irrigator name: $IRRIGATOR_NAME"

echo ""
echo "Viewing GreenSense irrigator MQTT bridge log..."

IRRIGATOR_MQTT_BRIDGE_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u greensense-mqtt-bridge-$IRRIGATOR_NAME.service -b")

echo "${IRRIGATOR_MQTT_BRIDGE_LOG}"

echo ""
echo "Viewing irrigator MQTT bridge service status..."
IRRIGATOR_MQTT_BRIDGE_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-mqtt-bridge-$IRRIGATOR_NAME.service")

echo "${IRRIGATOR_MQTT_BRIDGE_RESULT}"

[[ ! $(echo $IRRIGATOR_MQTT_BRIDGE_RESULT) =~ "Loaded: loaded" ]] && echo "The $IRRIGATOR_NAME MQTT bridge service isn't loaded" && exit 1
[[ ! $(echo $IRRIGATOR_MQTT_BRIDGE_RESULT) =~ "Active: active" ]] && echo "The $IRRIGATOR_NAME MQTT bridge service isn't active" && exit 1
[[ $(echo $IRRIGATOR_MQTT_BRIDGE_RESULT) =~ "not found" ]] && echo "The $IRRIGATOR_NAME MQTT bridge service wasn't found" && exit 1

echo ""
echo "Identifying ventilator name..."

VENTILATOR_NAME="ventilator1"
if [ "$BRANCH" = "lts" ]; then
  VENTILATOR_NAME="ventilator2"
fi
echo "  Ventilator name: $VENTILATOR_NAME"

echo ""
echo "Viewing GreenSense ventilator MQTT bridge log..."

VENTILATOR_MQTT_BRIDGE_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u greensense-mqtt-bridge-$VENTILATOR_NAME.service -b")

echo "${VENTILATOR_MQTT_BRIDGE_LOG}"

echo ""
echo "Viewing ventilator MQTT bridge service status..."

VENTILATOR_MQTT_BRIDGE_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-mqtt-bridge-$VENTILATOR_NAME.service")

echo "${VENTILATOR_MQTT_BRIDGE_RESULT}"

[[ ! $(echo $VENTILATOR_MQTT_BRIDGE_RESULT) =~ "Loaded: loaded" ]] && echo "The $VENTILATOR_NAME MQTT bridge service isn't loaded" && exit 1
[[ ! $(echo $VENTILATOR_MQTT_BRIDGE_RESULT) =~ "Active: active" ]] && echo "The $VENTILATOR_NAME MQTT bridge service isn't active" && exit 1
[[ $(echo $VENTILATOR_MQTT_BRIDGE_RESULT) =~ "not found" ]] && echo "The $VENTILATOR_NAME MQTT bridge service wasn't found" && exit 1

echo ""
echo "Identifying illuminator name..."
ILLUMINATOR_NAME="illuminator1"
if [ $BRANCH = "lts" ]; then
  ILLUMINATOR_NAME="illuminator2"
fi
echo "  Illuminator name: $ILLUMINATOR_NAME"

echo ""
echo "Viewing GreenSense illuminator MQTT bridge log..."

ILLUMINATOR_MQTT_BRIDGE_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u greensense-mqtt-bridge-$ILLUMINATOR_NAME.service -b")

echo "${ILLUMINATOR_MQTT_BRIDGE_LOG}"

echo ""
echo "Viewing illuminator MQTT bridge service status..."

ILLUMINATOR_MQTT_BRIDGE_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-mqtt-bridge-$ILLUMINATOR_NAME.service")

echo "${ILLUMINATOR_MQTT_BRIDGE_RESULT}"

[[ ! $(echo $ILLUMINATOR_MQTT_BRIDGE_RESULT) =~ "Loaded: loaded" ]] && echo "The $ILLUMINATOR_NAME MQTT bridge service isn't loaded" && exit 1
[[ ! $(echo $ILLUMINATOR_MQTT_BRIDGE_RESULT) =~ "Active: active" ]] && echo "The $ILLUMINATOR_NAME MQTT bridge service isn't active" && exit 1
[[ $(echo $ILLUMINATOR_MQTT_BRIDGE_RESULT) =~ "not found" ]] && echo "The $ILLUMINATOR_NAME MQTT bridge service wasn't found" && exit 1

echo ""
echo "Pulling update log files..."

mkdir -p logs/updates

sshpass -p $INSTALL_SSH_PASSWORD scp $INSTALL_SSH_USERNAME@$INSTALL_HOST:/usr/local/GreenSense/Index/logs/updates/*.txt logs/updates/

echo ""
echo "Checking update log files..."
for LOG_FILE in logs/updates/*.txt; do
  echo "Log file: $LOG_FILE"
  LOG_FILE_CONTENT=$(cat $LOG_FILE)
  
  [[ $(echo $LOG_FILE_CONTENT) =~ "failed" ]] && echo "Upgrade failed" && exit 1
  [[ $(echo $LOG_FILE_CONTENT) =~ "error" ]] && echo "Upgrade resulted in error" && exit 1
done

echo ""
echo "Viewing GreenSense supervisor service log..."

SUPERVISOR_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u greensense-supervisor.service -b")

echo "${SUPERVISOR_LOG}"

echo ""
echo "Viewing GreenSense supervisor service status..."

SUPERVISOR_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-supervisor.service")

echo "${SUPERVISOR_RESULT}"

[[ ! $(echo $SUPERVISOR_RESULT) =~ "Loaded: loaded" ]] && echo "GreenSense supervisor service isn't loaded" && exit 1
[[ ! $(echo $SUPERVISOR_RESULT) =~ "Active: active" ]] && echo "GreenSense supervisor service isn't active" && exit 1
[[ $(echo $SUPERVISOR_RESULT) =~ "not found" ]] && echo "GreenSense supervisor service wasn't found" && exit 1

echo ""
echo "Viewing garden data..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index; sh view-garden.sh"

echo ""
echo "Viewing garden status..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index; sh check-garden.sh"

echo ""
echo "Viewing garden device versions..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index; sh check-garden-device-versions.sh"

echo "Finished checking status of deployment."
echo ""
