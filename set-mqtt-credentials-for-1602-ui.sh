#!/bin/bash

echo ""
echo "Setting MQTT credentials for 1602 LCD shield UI controller..."
echo ""

HOST=$1
USERNAME=$2
PASSWORD=$3
PORT=$4

MOCK_UI_CONTROLLER_FLAG_FILE="is-mock-ui-controller.txt"

IS_MOCK_UI_CONTROLLER=0

if [ -f "$MOCK_UI_CONTROLLER_FLAG_FILE" ]; then
  IS_MOCK_UI_CONTROLLER=1
  echo "Is mock setup"
fi


if [ ! "$PORT" ]; then
  PORT="1883"
fi

if [ "$PASSWORD" ]; then

  echo "Host: $HOST"
  echo "Username: $USERNAME"
  echo "Port: $PORT"

  echo $HOST > "mqtt-host.security"
  echo $USERNAME > "mqtt-username.security"
  echo $PASSWORD > "mqtt-password.security"
  echo $PORT > "mqtt-port.security"

  echo ""
  echo "Setting UI controller config file:"
  
  CONFIG_FILE="scripts/apps/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController/lib/net40/Serial1602ShieldSystemUIController.exe.config"
  echo "  $CONFIG_FILE"
  
  if [ ! -f "$CONFIG_FILE.bak" ]; then
    echo "Backing up the original config file"
    cp $CONFIG_FILE $CONFIG_FILE.bak
  fi
  
  #echo "Restoring blank starter config file"
  #cp -f $CONFIG_FILE.bak $CONFIG_FILE
  
  echo "Inserting values"
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="Host"]/@value' -v "$HOST" $CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="UserId"]/@value' -v "$USERNAME" $CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="Password"]/@value' -v "$PASSWORD" $CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="MqttPort"]/@value' -v "$PORT" $CONFIG_FILE

  CONFIG_FILE2="scripts/apps/Serial1602ShieldSystemUIController/Serial1602ShieldSystemUIController.exe.config"
  
  echo "Keeping a backup of the new config file"
  echo "$CONFIG_FILE2"
  cp -f $CONFIG_FILE $CONFIG_FILE2

  echo "Installing config file to"
  
  if [ $IS_MOCK_UI_CONTROLLER = 0 ]; then
    echo "Real UI Controller"
    INSTALL_DIR="/usr/local/Serial1602ShieldSystemUIController"
    sudo mkdir -p $INSTALL_DIR
    sudo cp -f $CONFIG_FILE2 $INSTALL_DIR/Serial1602ShieldSystemUIController.exe.config
  else
    echo "Mock UI Controller"
    INSTALL_DIR="mock/Serial1602ShieldSystemUIController"
    mkdir -p $INSTALL_DIR
    cp -f $CONFIG_FILE2 $INSTALL_DIR/Serial1602ShieldSystemUIController.exe.config
  fi
  
  echo "$INSTALL_DIR/Serial1602ShieldSystemUIController.exe.config"

  echo ""
  echo "Finished setting MQTT credentials for 1602 LCD UI controller"
else
  echo "Please provide username and password as arguments"
fi
