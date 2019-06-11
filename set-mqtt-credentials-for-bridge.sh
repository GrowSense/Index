#!/bin/bash

echo ""
echo "Setting MQTT credentials for MQTT bridge..."

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

  INDEX_APP_PACKAGE_CONFIG_FILE="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config"

  echo ""
  echo "  Setting values in mqtt bridge config file:"
  echo "    $INDEX_APP_PACKAGE_CONFIG_FILE"
  
  if [ ! -f "$INDEX_APP_PACKAGE_CONFIG_FILE.bak" ]; then
    echo ""
    echo "  Backing up the original config file"
    echo "    From"
    echo "      $INDEX_APP_PACKAGE_CONFIG_FILE"
    echo "    To"
    echo "      $INDEX_APP_PACKAGE_CONFIG_FILE.bak"
    cp $INDEX_APP_PACKAGE_CONFIG_FILE $INDEX_APP_PACKAGE_CONFIG_FILE.bak
  fi
  
  # TODO: Remove if not needed
  #echo "Restoring blank starter config file"
  #cp -f $INDEX_APP_PACKAGE_CONFIG_FILE.bak $INDEX_APP_PACKAGE_CONFIG_FILE
  
  echo ""
  echo "  Inserting MQTT values into config file..."
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="Host"]/@value' -v "$HOST" $INDEX_APP_PACKAGE_CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="UserId"]/@value' -v "$USERNAME" $INDEX_APP_PACKAGE_CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="Password"]/@value' -v "$PASSWORD" $INDEX_APP_PACKAGE_CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="MqttPort"]/@value' -v "$PORT" $INDEX_APP_PACKAGE_CONFIG_FILE

  echo ""
  echo "  Checking MQTT values were inserted into config file..."
  INDEX_APP_PACKAGE_CONFIG_FILE_CONTENT=$(cat $INDEX_APP_PACKAGE_CONFIG_FILE)

  [[ ! $(echo $INDEX_APP_PACKAGE_CONFIG_FILE_CONTENT) =~ "$HOST" ]] && echo "The MQTT host wasn't inserted into the config file" && exit 1
  [[ ! $(echo $INDEX_APP_PACKAGE_CONFIG_FILE_CONTENT) =~ "$USERNAME" ]] && echo "The MQTT username wasn't inserted into the config file" && exit 1
  [[ ! $(echo $INDEX_APP_PACKAGE_CONFIG_FILE_CONTENT) =~ "$PASSWORD" ]] && echo "The MQTT password wasn't inserted into the config file" && exit 1
  [[ ! $(echo $INDEX_APP_PACKAGE_CONFIG_FILE_CONTENT) =~ "$PORT" ]] && echo "The MQTT port wasn't inserted into the config file" && exit 1

  INDEX_APP_CONFIG_FILE="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv.exe.config"
  
  echo ""
  echo "  Keeping a backup of the new config file"
  echo "    From"
  echo "      $INDEX_APP_PACKAGE_CONFIG_FILE"
  echo "    To"
  echo "      $INDEX_APP_CONFIG_FILE"
  cp -f $INDEX_APP_PACKAGE_CONFIG_FILE $INDEX_APP_CONFIG_FILE || exit 1

  echo ""
  echo "  Installing config file to..."
  
  # sudo is used for a real installation, but not used for a mock installation
  SUDO=""
  
  if [ $IS_MOCK_MQTT_BRIDGE = 0 ]; then
    echo "    Real MQTT bridge"
    INSTALL_DIR="/usr/local/BridgeArduinoSerialToMqttSplitCsv"
    # Enable sudo for real installation
    SUDO="sudo"
  else
    echo "    Mock MQTT bridge"
    INSTALL_DIR="mock/BridgeArduinoSerialToMqttSplitCsv"
    # Disable sudo for mock installation
    SUDO=""
  fi
  
  $SUDO mkdir -p $INSTALL_DIR || exit 1
  $SUDO cp -f $INDEX_APP_PACKAGE_CONFIG_FILE $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config || exit 1
  
  INSTALL_CONFIG_FILE="$INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config"
  INSTALL_PACKAGE_DIR="$INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv/lib/net40"
  INSTALL_PACKAGE_CONFIG_FILE="$INSTALL_PACKAGE_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config"
  
  echo "    Directory:"
  echo "      $INSTALL_DIR"
  echo "    File:"
  echo "      $INSTALL_CONFIG_FILE"

  if [ ! -d $INSTALL_PACKAGE_DIR ]; then
    echo ""
    echo "  Creating install package directory..."
    $SUDO mkdir -p $INSTALL_PACKAGE_DIR || exit 1
  fi  
  
  echo ""
  echo "  Copying config file into install package directory..."
  echo "    From:"
  echo "      $INSTALL_CONFIG_FILE"
  echo "    To:"
  echo "      $INSTALL_PACKAGE_CONFIG_FILE"
  $SUDO cp -f $INSTALL_CONFIG_FILE $INSTALL_PACKAGE_CONFIG_FILE || exit 1

  echo ""
  echo "Finished setting MQTT credentials for MQTT bridge"
else
  echo "Please provide username and password as arguments"
fi
