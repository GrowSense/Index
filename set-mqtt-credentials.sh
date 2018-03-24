#!/bin/bash

echo ""
echo "Setting mosquitto MQTT credentials..."
echo ""

USERNAME=$1
PASSWORD=$2

if [ "$PASSWORD" ]; then

  echo "Username: $USERNAME"

  CREDENTIALS_FILE="scripts/docker/mosquitto/data/mosquitto.userfile"

  echo "$USERNAME:$PASSWORD" > CREDENTIALS_FILE

  echo "Credentials file:"
  echo "  $CREDENTIALS_FILE"

  echo ""
  echo "Finished setting username and password"
else
  echo "Please provide username and password as arguments"
fi
