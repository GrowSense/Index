#!/bin/bash

echo ""
echo "Setting MQTT credentials..."

HOST=$1
USERNAME=$2
PASSWORD=$3
PORT=$4


if [ ! "$PORT" ]; then
  PORT="1883"
fi

if [ "$PASSWORD" ]; then

  echo "  Host: $HOST"
  echo "  Username: $USERNAME"
  echo "  Password: [hidden]"
  echo "  Port: $PORT"

  echo $HOST > "mqtt-host.security"
  echo $USERNAME > "mqtt-username.security"
  echo $PASSWORD > "mqtt-password.security"
  echo $PORT > "mqtt-port.security"

  CREDENTIALS_FILE="scripts/docker/mosquitto/data/mosquitto.userfile"

  echo "$USERNAME:$PASSWORD" > $CREDENTIALS_FILE

  echo "  Setting credentials file:"
  echo "    $CREDENTIALS_FILE"

  sh set-mqtt-credentials-for-bridge.sh $HOST $USERNAME $PASSWORD $PORT
  sh set-mqtt-credentials-for-1602-ui.sh $HOST $USERNAME $PASSWORD $PORT

  echo "Finished setting MQTT credentials."
  echo ""

else
  echo "Please provide username and password as arguments"
fi
