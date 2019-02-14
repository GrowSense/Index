#!/bin/bash

echo ""
echo "Setting mosquitto MQTT credentials..."
echo ""

HOST=$1
USERNAME=$2
PASSWORD=$3
PORT=$4

MOCK_MQTT_BRIDGE_FLAG_FILE="is-mock-mqtt-bridge.txt"

IS_MOCK_MQTT_BRIDGE=0

if [ -f "$MOCK_MQTT_BRIDGE_FLAG_FILE" ]; then
  IS_MOCK_MQTT_BRIDGE=1
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

  CREDENTIALS_FILE="scripts/docker/mosquitto/data/mosquitto.userfile"

  echo "$USERNAME:$PASSWORD" > $CREDENTIALS_FILE

  echo "Setting credentials file:"
  echo "  $CREDENTIALS_FILE"


  echo ""
  echo "Setting mqtt bridge config file:"
  
  BRIDGE_SERVICE_CONFIG_FILE="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config"
  echo "  $BRIDGE_SERVICE_CONFIG_FILE"
  
  if [ ! -f "$BRIDGE_SERVICE_CONFIG_FILE.bak" ]; then
    echo "Backing up the original config file"
    cp $BRIDGE_SERVICE_CONFIG_FILE $BRIDGE_SERVICE_CONFIG_FILE.bak
  fi
  
  echo "Restoring blank starter config file"
  cp -f $BRIDGE_SERVICE_CONFIG_FILE.bak $BRIDGE_SERVICE_CONFIG_FILE
  
  echo "Inserting values"
  sed -i "s/localhost/$HOST/g" $BRIDGE_SERVICE_CONFIG_FILE && \
  sed -i "s/user/$USERNAME/g" $BRIDGE_SERVICE_CONFIG_FILE && \
  sed -i "s/123456/$PASSWORD/g" $BRIDGE_SERVICE_CONFIG_FILE
  sed -i "s/1883/$PORT/g" $BRIDGE_SERVICE_CONFIG_FILE


  BRIDGE_SERVICE_CONFIG_FILE2="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv.exe.config"
  
  echo "Keeping a backup of the new config file"
  echo "$BRIDGE_SERVICE_CONFIG_FILE2"
  cp -f $BRIDGE_SERVICE_CONFIG_FILE $BRIDGE_SERVICE_CONFIG_FILE2

  echo "Installing config file to"
  
  if [ $IS_MOCK_MQTT_BRIDGE = 0 ]; then
    echo "Real MQTT bridge"
    INSTALL_DIR="/usr/local/mqtt-bridge"
    sudo mkdir -p $INSTALL_DIR
    sudo cp -f $BRIDGE_SERVICE_CONFIG_FILE2 $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config
  else
    echo "Mock MQTT bridge"
    INSTALL_DIR="mock/mqtt-bridge"
    mkdir -p $INSTALL_DIR
    cp -f $BRIDGE_SERVICE_CONFIG_FILE2 $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config
  fi
  
  echo "$INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv.exe.config"

  echo ""
  echo "Finished setting MQTT credentials"
else
  echo "Please provide username and password as arguments"
fi
