DEVICE_NAME=$1
MQTT_KEY=$2
MQTT_VALUE=$3

EXAMPLE_COMMAND="Example:\n..sh [MyDevice] [Key] [Value]"

if [ ! $DEVICE_NAME ]; then
  echo "Please specify a device name as an argument."
  echo $EXAMPLE_COMMAND
  exit 1
fi
if [ ! $MQTT_KEY ]; then
  echo "Please specify an MQTT key as an argument."
  echo $EXAMPLE_COMMAND
  exit 1
fi
if [ ! $MQTT_VALUE ]; then
  echo "Please specify an MQTT value as an argument."
  echo $EXAMPLE_COMMAND
  exit 1
fi

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USER=$(cat mqtt-username.security)
MQTT_PASS=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

echo "Device name: $DEVICE_NAME"
echo "MQTT Host: $MQTT_HOST"
echo "MQTT User: $MQTT_USER"
echo "MQTT Pass: [hidden]"
echo "MQTT Port: $MQTT_PORT"

echo "MQTT Key: $MQTT_KEY"
echo "MQTT Value: $MQTT_PORT"

MQTT_TOPIC="$DEVICE_NAME/$MQTT_KEY"

echo "MQTT Topic: $MQTT_TOPIC"

mosquitto_pub -h $MQTT_HOST -t $MQTT_TOPIC -u $MQTT_USER -P $MQTT_PASS -m "$MQTT_VALUE" -p $MQTT_PORT
