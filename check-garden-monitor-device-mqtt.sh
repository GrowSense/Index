DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

# Query the device for a line of data...
mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Q/in" -m "1" -q 2

CALIBRATED_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/C" -C 1 -q 2)

if [ ! $CALIBRATED_VALUE ]; then
  echo "  Soil moisture: No MQTT data detected"  
else
  echo "  Soil moisture: $CALIBRATED_VALUE%"
fi
