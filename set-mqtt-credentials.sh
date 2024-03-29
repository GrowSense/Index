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
  
  bash gs.sh config --mqtt-host=$HOST --mqtt-username=$USERNAME --mqtt-password=$PASSWORD --mqtt-port=$PORT --verify=false

#  CREDENTIALS_FILE="$PWD/scripts/docker/mosquitto/data/mosquitto.userfile"

#  echo ""
#  echo "  Setting mosquitto credentials file:"
#  echo "    $CREDENTIALS_FILE"
#  echo "$USERNAME:$PASSWORD" > $CREDENTIALS_FILE

  # Clear existing file
#  if [ -f "$CREDENTIALS_FILE" ]; then
#    rm $CREDENTIALS_FILE
#  fi
#  touch $CREDENTIALS_FILE
#  mosquitto_passwd -b "$CREDENTIALS_FILE" "$USERNAME" "$PASSWORD" || exit 1
#  sudo mkdir -p /usr/local/mosquitto/data || exit 1
#  sudo cp -v $CREDENTIALS_FILE /usr/local/mosquitto/data/mosquitto.userfile || exit 1


#  bash set-mqtt-credentials-for-www.sh $HOST $USERNAME $PASSWORD $PORT || exit 1
#  bash set-mqtt-credentials-for-bridge.sh $HOST $USERNAME $PASSWORD $PORT || exit 1
#  bash set-mqtt-credentials-for-1602-ui.sh $HOST $USERNAME $PASSWORD $PORT || exit 1

  echo ""
  echo "Finished setting MQTT credentials."
  echo ""

else
  echo "Please provide username and password as arguments"
fi
