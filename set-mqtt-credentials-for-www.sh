#!/bin/bash

echo ""
echo "Setting MQTT credentials for SystemManager..."

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

  CONFIG_FILE="www/SystemManagerWWW/src/GrowSense.SystemManager.WWW/web.config"

  echo ""
  echo "  Setting MQTT values in SystemManager config file:"
  echo "    $CONFIG_FILE"
    
  echo ""
  echo "  Inserting MQTT values into config file..."
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="MqttHost"]/@value' -v "$HOST" $CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="MqttUsername"]/@value' -v "$USERNAME" $CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="MqttPassword"]/@value' -v "$PASSWORD" $CONFIG_FILE
  xmlstarlet ed -L -u '/configuration/appSettings/add[@key="MqttPort"]/@value' -v "$PORT" $CONFIG_FILE

  echo ""
  echo "  Checking MQTT values were inserted into config file..."
  CONFIG_FILE_CONTENT=$(cat $CONFIG_FILE)

  [[ ! $(echo $CONFIG_FILE_CONTENT) =~ "$HOST" ]] && echo "The MQTT host wasn't inserted into the config file" && exit 1
  [[ ! $(echo $CONFIG_FILE_CONTENT) =~ "$USERNAME" ]] && echo "The MQTT username wasn't inserted into the config file" && exit 1
  [[ ! $(echo $CONFIG_FILE_CONTENT) =~ "$PASSWORD" ]] && echo "The MQTT password wasn't inserted into the config file" && exit 1
  [[ ! $(echo $CONFIG_FILE_CONTENT) =~ "$PORT" ]] && echo "The MQTT port wasn't inserted into the config file" && exit 1

  echo ""
  echo "Finished setting MQTT credentials for SystemManager"
else
  echo "Please provide username and password as arguments"
fi
