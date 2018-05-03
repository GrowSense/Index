#!/bin/bash

echo ""
echo "Setting mosquitto MQTT credentials..."
echo ""

HOST=$1
USERNAME=$2
PASSWORD=$3
PORT=$4


if [ ! "$PORT" ]; then
  PORT="1883"
fi

if [ "$PASSWORD" ]; then

  echo "Host: $USERNAME"
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
  sed -i "s/localhost/$HOST/g" $BRIDGE_SERVICE_CONFIG_FILE && \
  sed -i "s/user/$USERNAME/g" $BRIDGE_SERVICE_CONFIG_FILE && \
  sed -i "s/123456/$PASSWORD/g" $BRIDGE_SERVICE_CONFIG_FILE

  echo ""
  echo "Finished setting MQTT credentials"
else
  echo "Please provide username and password as arguments"
fi
