echo "Supervising MQTT server..."

HOST=$(cat /etc/hostname)

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

echo "  Checking docker processes..."
DOCKER_PS_RESULT="$(docker ps)"
echo "    Result:"
echo "$DOCKER_PS_RESULT"
echo ""

if [[ ! $(echo $DOCKER_PS_RESULT) =~ "mosquitto" ]]; then
  echo "    Mosquitto docker service not found. Creating..."
  bash create-mqtt-service.sh
fi

echo ""
echo "  Pinging MQTT server..."
echo "    MQTT Host: $MQTT_HOST"
PING_MQTT_RESULT="$(ping -c 1 $MQTT_HOST)"

HOST=$(cat /etc/hostname)

echo ""
echo "  Ping result..."
echo "${PING_MQTT_RESULT}"

if [[ ! $(echo $PING_MQTT_RESULT) =~ "64 bytes from" ]]; then
  echo "  MQTT broker/server is down or inaccessible..."

  bash send-email.sh "Error: MQTT server $MQTT_HOST is down or inaccessible (from $HOST)" "Failed to ping MQTT server...\n\nMQTT Host: $MQTT_HOST\nGarden Computer: $HOST\n\nPing result...\n\n${PING_MQTT_RESULT}"

  bash create-alert-file.sh "MQTT server $MQTT_HOST is down or inaccessible (from $HOST)"

  exit 1
elif [[ $(echo $PING_MQTT_RESULT) =~ "Destination Host Unreachable" ]]; then
  echo "  MQTT broker/server is down or inaccessible..."

  bash send-email.sh "Error: MQTT server $MQTT_HOST is down or inaccessible (from $HOST)" "Failed to ping MQTT server...\n\nMQTT Host: $MQTT_HOST\nGarden Computer: $HOST\n\nPing result...\n\n${PING_MQTT_RESULT}"

  bash create-alert-file.sh "MQTT server $MQTT_HOST is down or inaccessible (from $HOST)"

  exit 1
elif [[ $(echo $PING_MQTT_RESULT) =~ "unknown host" ]]; then
  echo "  MQTT broker/server is down or inaccessible..."

  bash send-email.sh "Error: MQTT server $MQTT_HOST is down or inaccessible (from $HOST)" "Failed to ping MQTT server...\n\nMQTT Host: $MQTT_HOST\nGarden Computer: $HOST\n\nPing result...\n\n${PING_MQTT_RESULT}"

  bash create-alert-file.sh "MQTT server $MQTT_HOST is down or inaccessible (from $HOST)"

  exit 1
fi

echo ""
echo "  Sending data to MQTT broker..."

TOPIC="$HOST/supervisortest/value"
VALUE="$(date)"

echo "    Topic: $TOPIC"
echo "    Value: $VALUE"

PUBLISH_RESULT=$(mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$TOPIC" -m "$VALUE" -q 2 -r)

# Disabled because this check isn't working. The read MQTT data check will still detect a failure so this check isn't necessary
#if [[ $(echo $PUBLISH_RESULT) =~ "Connection refused" ]]; then
#  echo "  MQTT broker/server publish failed. Connection refused..."
#  echo "  Publish result..."
#  echo "${PUBLISH_RESULT}"
#  bash send-email.sh "Error: MQTT server $MQTT_HOST refused connection (from $HOST)" "Failed to publish data to MQTT server...\n\nMQTT Host: $MQTT_HOST\nGarden Computer: $HOST\n\nPublish result...\n\n${PUBLISH_RESULT}"
#  exit 1
#else
#  echo "  MQTT publish appears to be successful..."
#fi

sleep 3

echo ""
echo "  Reading data from MQTT broker..."
DETECTED_VALUE=$(timeout 10 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$TOPIC" -C 1 -q 2)

echo "    Detected value: $DETECTED_VALUE"

if [ "$DETECTED_VALUE" != "$VALUE" ]; then
  echo "  MQTT broker isn't communicating. The MQTT broker service may be down..."

  bash send-email.sh "Error: MQTT broker on $MQTT_HOST isn't communicating (from $HOST) " "MQTT broker failed send/receive data test, therefore is failing to communicate. The MQTT broker service may be down...\n\nMQTT Host: $MQTT_HOST\nGarden Computer: $HOST\n\nValue sent: $VALUE\nValue detected: $DETECTED_VALUE"

  bash create-alert-file.sh "MQTT broker on $MQTT_HOST isn't communicating (from $HOST)"

  exit 1
else
  echo "  MQTT broker is communicating properly"
fi

echo ""
echo "Finished supervising MQTT server."
