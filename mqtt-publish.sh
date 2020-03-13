TOPIC=$1
MESSAGE=$2

EXAMPLE_USAGE="Example:\n...sh [Topic] [Message]"

if [ ! "$TOPIC" ]; then
  echo "Please provide a topic as an argument."
  echo $EXAMPLE_USAGE
  exit 1
fi

if [ ! "$MESSAGE" ]; then
  echo "Please provide a message as an argument."
  echo $EXAMPLE_USAGE
  exit 1
fi

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

echo "Publishing to MQTT..."
echo "  Topic: $TOPIC"
echo "  Message: $MESSAGE"
echo "  MQTT Host: $MQTT_HOST"
echo "  MQTT Username: $MQTT_USERNAME"
echo "  MQTT Password: [hidden]"
echo "  MQTT Port: $MQTT_PORT"

TIMEOUT=10s

if [ ! -f "is-mock-mqtt.txt" ]; then
  timeout $TIMEOUT mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$TOPIC" -m "$MESSAGE" $3 $4 $5 $6 $7 $8 || exit 1
else
  echo "[mock] mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P [hidden] -p $MQTT_PORT -t \"$TOPIC\" -m \"$MESSAGE\" $3 $4 $5 $6 $7 $8"
fi

echo "Successfully published MQTT message."
