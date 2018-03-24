#!/bin/bash

echo ""
echo "Setting mosquitto MQTT credentials..."
echo ""

USERNAME=$1
PASSWORD=$2

if [ "$PASSWORD" ]; then

  echo "Username: $USERNAME"

  CREDENTIALS_FILE="scripts/docker/mosquitto/data/mosquitto.userfile"

  echo "$USERNAME:$PASSWORD" > $CREDENTIALS_FILE

  echo "Setting credentials file:"
  echo "  $CREDENTIALS_FILE"


  echo "Setting mqtt bridge config file:"
  echo "  $CREDENTIALS_FILE"
  BRIDGE_SERVICE_CONFIG_FILE="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config"
  sed -i "s/user/$USERNAME/g" $BRIDGE_SERVICE_CONFIG_FILE && \
  sed -i "s/123456/$PASSWORD/g" $BRIDGE_SERVICE_CONFIG_FILE

  echo ""
  echo "Finished setting username and password"
else
  echo "Please provide username and password as arguments"
fi
