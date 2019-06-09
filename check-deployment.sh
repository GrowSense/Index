#!/bin/bash

echo ""
echo "Checking status of deployment..."
echo ""

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')


# Detect the deployment details
. ./detect-deployment-details.sh

echo "Host: $INSTALL_HOST"
echo "Branch: $BRANCH"

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

PNP_CONTROLLER_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u arduino-plug-and-play.service -b | tail -n 300")

echo "${PNP_CONTROLLER_LOG}"

echo ""
echo "Viewing arduino plug and play service status..."

PNP_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status arduino-plug-and-play.service")

echo "${PNP_RESULT}"

[[ ! $(echo $PNP_RESULT) =~ "Loaded: loaded" ]] && echo "Arduino Plug and Play service isn't loaded" && exit 1
[[ ! $(echo $PNP_RESULT) =~ "Active: active" ]] && echo "Arduino Plug and Play service isn't active" && exit 1
[[ $(echo $PNP_RESULT) =~ "not found" ]] && echo "Arduino Plug and Play service wasn't found" && exit 1

echo ""
echo "Checking deployment devices..."

bash check-deployment-devices.sh $BRANCH || exit 1

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

SUPERVISOR_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u greensense-supervisor.service -b | tail -n 100")

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
