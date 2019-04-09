DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

GROUP=$(cat "devices/$DEVICE_NAME/group.txt")

STATUS_MESSAGE=$(timeout 10 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/StatusMessage" -C 1)

if [ ! $STATUS_MESSAGE ]; then
  echo "  No MQTT status message detected"  
else
  echo "  Status: $STATUS_MESSAGE"
fi

# Soil moisture monitor
if [ "$GROUP" = "monitor" ]; then
  sh check-garden-monitor-device-mqtt.sh $DEVICE_NAME
fi

# Irrigator
if [ "$GROUP" = "irrigator" ]; then
  sh check-garden-irrigator-device-mqtt.sh $DEVICE_NAME
fi

# Illuminator
if [ "$GROUP" = "illuminator" ]; then
  sh check-garden-illuminator-device-mqtt.sh $DEVICE_NAME
fi

# Ventilator
if [ "$GROUP" = "ventilator" ]; then
  sh check-garden-ventilator-device-mqtt.sh $DEVICE_NAME
fi
