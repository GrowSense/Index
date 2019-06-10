#!/bin/bash

echo ""
echo "Setting MQTT credentials for MQTT bridge..."
echo ""

HOST=$1
USERNAME=$2
PASSWORD=$3
PORT=$4

MOCK_MQTT_BRIDGE_FLAG_FILE="is-mock-mqtt-bridge.txt"

IS_MOCK_MQTT_BRIDGE=0

if [ -f "$MOCK_MQTT_BRIDGE_FLAG_FILE" ]; then
  IS_MOCK_MQTT_BRIDGE=1
  echo "  Is mock setup"
fi


if [ ! "$PORT" ]; then
  PORT="1883"
fi

if [ "$PASSWORD" ]; then

  echo "  Host: $HOST"
  echo "  Username: $USERNAME"
  echo "  Port: $PORT"

  echo $HOST > "mqtt-host.security"
  echo $USERNAME > "mqtt-username.security"
  echo $PASSWORD > "mqtt-password.security"
  echo $PORT > "mqtt-port.security"

  CONFIG_FILE="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config"

  echo ""
  echo "  Setting values in mqtt bridge config file:"
  echo "    $CONFIG_FILE"
  
  if [ ! -f "$CONFIG_FILE.bak" ]; then
    echo ""
    echo "  Backing up the original config file"
    echo "    From"
    echo "      $CONFIG_FILE"
    echo "    To"
    echo "      $CONFIG_FILE.bak"
    cp $CONFIG_FILE $CONFIG_FILE.bak
  fi
  
  # TODO: Remove if not needed
  #echo "Restoring blank starter config file"
  #cp -f $CONFIG_FILE.bak $CONFIG_FILE
  
  echo ""
  echo "  Inserting MQTT values into config file"
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="Host"]/@value' -v "$HOST" $CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="UserId"]/@value' -v "$USERNAME" $CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="Password"]/@value' -v "$PASSWORD" $CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="MqttPort"]/@value' -v "$PORT" $CONFIG_FILE

  CONFIG_FILE2="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv.exe.config"
  
  echo ""
  echo "  Keeping a backup of the new config file"
  echo "    From"
  echo "      $CONFIG_FILE"
  echo "    To"
  echo "      $CONFIG_FILE2"
  cp -f $CONFIG_FILE $CONFIG_FILE2

  echo ""
  echo "  Installing config file to..."
  
  if [ $IS_MOCK_MQTT_BRIDGE = 0 ]; then
    echo "    Real MQTT bridge"
    INSTALL_DIR="/usr/local/BridgeArduinoSerialToMqttSplitCsv"
    sudo mkdir -p $INSTALL_DIR
    sudo cp -f $CONFIG_FILE2 $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config
  else
    echo "    Mock MQTT bridge"
    INSTALL_DIR="mock/BridgeArduinoSerialToMqttSplitCsv"
    mkdir -p $INSTALL_DIR
    cp -f $CONFIG_FILE2 $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config
  fi
  
  echo "    Directory:"
  echo "      $INSTALL_DIR"
  echo "    File:"
  echo "      $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config"

  echo ""
  echo "Finished setting MQTT credentials for MQTT bridge"
else
  echo "Please provide username and password as arguments"
fi
