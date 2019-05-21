DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

# Query the device to force it to output a line of data
mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Q" -m "1"

# Give the device time to respond
sleep 2

GROUP=$(cat "devices/$DEVICE_NAME/group.txt")

# Soil moisture monitor
if [ "$GROUP" = "monitor" ]; then
  sh view-garden-monitor-device-mqtt.sh $DEVICE_NAME
fi

# Irrigator
if [ "$GROUP" = "irrigator" ]; then
  sh view-garden-irrigator-device-mqtt.sh $DEVICE_NAME
fi

# Illuminator
if [ "$GROUP" = "illuminator" ]; then
  sh view-garden-illuminator-device-mqtt.sh $DEVICE_NAME
fi

# Ventilator
if [ "$GROUP" = "ventilator" ]; then
  sh view-garden-ventilator-device-mqtt.sh $DEVICE_NAME
fi
