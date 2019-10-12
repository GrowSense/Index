#!/bin/bash

echo ""
echo "Checking status of deployment..."
echo ""

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')


# Detect the deployment details
. ./detect-deployment-details.sh

echo "Host: $INSTALL_HOST"
echo "Branch: $BRANCH"
echo "MQTT Host: $INSTALL_MQTT_HOST"
echo "MQTT Username: $INSTALL_MQTT_USERNAME"
echo "MQTT Password: [hidden]"
echo "MQTT Port: $INSTALL_MQTT_PORT"

echo ""
echo "Waiting for plug and play..."
sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash wait-for-plug-and-play.sh"

#echo ""
#echo "Setting supervisor status check frequency to 1 so it gets updated quickly..."

#sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && echo 1 > supervisor-status-check-frequency.txt && sudo systemctl restart greensense-supervisor.service"

echo ""
echo "Viewing platform.io list..."

PIO_LIST_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "pio device list")

echo "${PIO_LIST_RESULT}"

[[ ! $(echo $PIO_LIST_RESULT) =~ "ttyUSB" ]] && echo "No USB devices are connected" && exit 1

echo ""
echo "Viewing docker ps result..."

DOCKER_PS_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "docker ps")

echo "${DOCKER_PS_RESULT}"

# Disabled because mosquitto is only installed when MQTT is running on localhost
#[[ ! $(echo $DOCKER_PS_RESULT) =~ "mosquitto" ]] && echo "Mosquitto docker container not detected" && exit 1

echo ""
echo "Checking MQTT bridge config file..."

MQTT_BRIDGE_CONFIG_CONTENT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cat /usr/local/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config")

# Disabled because this would expose the MQTT password
#echo "${MQTT_BRIDGE_CONFIG_CONTENT}"

[[ ! $(echo $MQTT_BRIDGE_CONFIG_CONTENT) =~ "key=\"Host\" value=\"$INSTALL_MQTT_HOST\"" ]] && echo "MQTT bridge config file doesn't contain the correct MQTT host" && exit 1
[[ ! $(echo $MQTT_BRIDGE_CONFIG_CONTENT) =~ "key=\"UserId\" value=\"$INSTALL_MQTT_USERNAME\"" ]] && echo "MQTT bridge config file doesn't contain the correct MQTT username" && exit 1
[[ ! $(echo $MQTT_BRIDGE_CONFIG_CONTENT) =~ "key=\"Password\" value=\"$INSTALL_MQTT_PASSWORD\"" ]] && echo "MQTT bridge config file doesn't contain the correct MQTT password" && exit 1
[[ ! $(echo $MQTT_BRIDGE_CONFIG_CONTENT) =~ "key=\"SmtpServer\" value=\"$SMTP_SERVER\"" ]] && echo "MQTT bridge config file doesn't contain the correct SMTP server" && exit 1
[[ ! $(echo $MQTT_BRIDGE_CONFIG_CONTENT) =~ "key=\"EmailAddress\" value=\"$EMAIL_ADDRESS\"" ]] && echo "MQTT bridge config file doesn't contain the correct email address" && exit 1

echo ""
echo "Checking serial UI controller config file..."

UI_CONTROLLER_CONFIG_CONTENT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cat /usr/local/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController/lib/net40/Serial1602ShieldSystemUIControllerConsole.exe.config")

# Disabled because this would expose the MQTT password
#echo "${UI_CONTROLLER_CONFIG_CONTENT}"

[[ ! $(echo $UI_CONTROLLER_CONFIG_CONTENT) =~ "key=\"Host\" value=\"$INSTALL_MQTT_HOST\"" ]] && echo "Serial UI controller config file doesn't contain the correct MQTT host" && exit 1
[[ ! $(echo $UI_CONTROLLER_CONFIG_CONTENT) =~ "key=\"UserId\" value=\"$INSTALL_MQTT_USERNAME\"" ]] && echo "Serial UI controller config file doesn't contain the correct MQTT username" && exit 1
[[ ! $(echo $UI_CONTROLLER_CONFIG_CONTENT) =~ "key=\"Password\" value=\"$INSTALL_MQTT_PASSWORD\"" ]] && echo "Serial UI controller config file doesn't contain the correct MQTT password" && exit 1
[[ ! $(echo $UI_CONTROLLER_CONFIG_CONTENT) =~ "key=\"SmtpServer\" value=\"$SMTP_SERVER\"" ]] && echo "Serial UI controller config file doesn't contain the correct SMTP server" && exit 1
[[ ! $(echo $UI_CONTROLLER_CONFIG_CONTENT) =~ "key=\"EmailAddress\" value=\"$EMAIL_ADDRESS\"" ]] && echo "Serial UI controller config file doesn't contain the correct email address" && exit 1

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
echo "Viewing GrowSense Plug and Play service log..."

PNP_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u arduino-plug-and-play.service -b")

echo "${PNP_LOG}"

echo ""
echo "Viewing arduino plug and play service status..."

PNP_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status arduino-plug-and-play.service")

echo "${PNP_RESULT}"

[[ ! $(echo $PNP_RESULT) =~ "Loaded: loaded" ]] && echo "Arduino Plug and Play service isn't loaded" && exit 1
[[ ! $(echo $PNP_RESULT) =~ "Active: active" ]] && echo "Arduino Plug and Play service isn't active" && exit 1
[[ $(echo $PNP_RESULT) =~ "not found" ]] && echo "Arduino Plug and Play service wasn't found" && exit 1
[[ $(echo $PNP_RESULT) =~ "(unusable)" ]] && echo "Arduino Plug and Play detected an unusable device when it shouldn't" && exit 1

#echo ""
#echo "Supervising devices..."
# Disabled because it conflicts with the supervisor service
#SUPERVISE_DEVICES_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index/ && bash supervise-devices.sh 1")

#echo "${SUPERVISE_DEVICES_RESULT}"

echo ""
echo "Checking deployment devices..."

bash check-deployment-devices.sh $BRANCH || exit 1

echo ""
echo "Pulling update log files..."

if [ -d logs/updates ]; then
  rm logs/updates -r
fi
mkdir -p logs/updates

sshpass -p $INSTALL_SSH_PASSWORD scp $INSTALL_SSH_USERNAME@$INSTALL_HOST:/usr/local/GrowSense/Index/logs/updates/*.txt logs/updates/

echo ""
echo "Checking update log files..."
for LOG_FILE in logs/updates/*.txt; do
  echo "Log file: $LOG_FILE"
  LOG_FILE_CONTENT=$(cat $LOG_FILE)
  
#  [[ $(echo $LOG_FILE_CONTENT) =~ "failed" ]] && echo "Upgrade failed" && echo "Content:\n${LOG_FILE_CONTENT}\n" && exit 1
#  [[ $(echo $LOG_FILE_CONTENT) =~ "error" ]] && echo "Upgrade resulted in error" && echo "Content:\n${LOG_FILE_CONTENT}\n" && exit 1
done

echo ""
echo "Viewing GrowSense supervisor service log..."

SUPERVISOR_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u greensense-supervisor.service -b | tail -n 200")

echo "${SUPERVISOR_LOG}"

echo ""
echo "Viewing GrowSense supervisor service status..."

SUPERVISOR_RESULT=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status greensense-supervisor.service")

echo "${SUPERVISOR_RESULT}"

[[ ! $(echo $SUPERVISOR_RESULT) =~ "Loaded: loaded" ]] && echo "GrowSense supervisor service isn't loaded" && exit 1
[[ ! $(echo $SUPERVISOR_RESULT) =~ "Active: active" ]] && echo "GrowSense supervisor service isn't active" && exit 1
[[ $(echo $SUPERVISOR_RESULT) =~ "not found" ]] && echo "GrowSense supervisor service wasn't found" && exit 1

echo ""
echo "Listing device info directories..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index; ls devices"

echo ""
echo "Viewing garden data..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index; sh view-garden.sh"

echo ""
echo "Checking garden status..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index; sh check-garden.sh"

echo ""
echo "Viewing garden device versions..."

sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index; sh check-garden-device-versions.sh"

#echo ""
#echo "Setting supervisor status check frequency back to default..."

#sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && git checkout supervisor-status-check-frequency.txt && sudo systemctl restart greensense-supervisor.service"

echo "Finished checking status of deployment."
echo ""
