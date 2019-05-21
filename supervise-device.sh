DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

echo ""
echo "Querying the device for a line of data..."
mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Q/in" -m "1"

echo ""
echo "Giving the device time to receive the message..."
sleep 5

echo ""
echo "Getting the time stamp from the device..."
TIME=$(timeout 30 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Time" -C 1)

echo "Time: $TIME"

DEVICE_TIME_FILE="devices/$DEVICE_NAME/time-last-published.txt"

PREVIOUS_TIME=""
if [ -f $DEVICE_TIME_FILE ]; then
  PREVIOUS_TIME=$(cat $DEVICE_TIME_FILE)
fi

echo "Previous time: $PREVIOUS_TIME"

if [ "$TIME" = "$PREVIOUS_TIME" ]; then
  echo "  No MQTT data. Device is offline."  
  
  sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Offline"
else
  echo "  Device is online."
  
  sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Online"
  
  echo $TIME > $DEVICE_TIME_FILE
fi

echo "Finished supervising device"
echo ""
