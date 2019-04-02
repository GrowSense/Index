#!/bin/bash

echo ""
echo "Setting email details for MQTT bridge..."
echo ""

SMTP_SERVER=$1
ADMIN_EMAIL=$2


if [ ! "$SMTP_SERVER" ]; then
  echo "Please provide an SMTP server as an argument."
  exit 1
fi

if [ ! "$ADMIN_EMAIL" ]; then
  echo "Please provide an admin email address as an argument."
  exit 1
fi
 
IS_MOCK_MQTT_BRIDGE=0
if [ -f "is-mock-mqtt-bridge.txt" ]; then
  IS_MOCK_MQTT_BRIDGE=1
  echo "Is mock setup"
fi

echo "SMTP server: $SMTP_SERVER"
echo "Admin email: $ADMIN_EMAIL"

echo ""
echo "Setting mqtt bridge config file:"

CONFIG_FILE="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config"
echo "  $CONFIG_FILE"

if [ ! -f "$CONFIG_FILE.bak" ]; then
  echo "Backing up the original config file"
  cp $CONFIG_FILE $CONFIG_FILE.bak
fi

echo "Restoring blank starter config file"
cp -f $CONFIG_FILE.bak $CONFIG_FILE

echo "Inserting values"
xmlstarlet ed -L -u '/configuration/appSettings/add[@key="SmtpServer"]/@value' -v "$SMTP_SERVER" $CONFIG_FILE
xmlstarlet ed -L -u '/configuration/appSettings/add[@key="EmailAddress"]/@value' -v "$ADMIN_EMAIL" $CONFIG_FILE

CONFIG_FILE2="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv.exe.config"

echo "Keeping a backup of the new config file"
echo "$CONFIG_FILE2"
cp -f $CONFIG_FILE $CONFIG_FILE2

echo "Installing config file to"

if [ $IS_MOCK_MQTT_BRIDGE = 0 ]; then
  echo "Real MQTT bridge"
  INSTALL_DIR="/usr/local/mqtt-bridge"
  sudo mkdir -p $INSTALL_DIR
  sudo cp -f $CONFIG_FILE2 $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config
else
  echo "Mock MQTT bridge"
  INSTALL_DIR="mock/mqtt-bridge"
  mkdir -p $INSTALL_DIR
  cp -f $CONFIG_FILE2 $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config
fi

echo "$INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config"

echo ""
echo "Finished setting MQTT credentials"
