DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

HOST=$(cat /etc/hostname)

echo ""
echo "Querying the device for a line of data..."
mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Q/in" -m "1" -q 2

echo ""
echo "Giving the device time to receive the message..."
sleep 5

echo ""
echo "Getting the time stamp from the device..."
PREVIOUS_TIME=$(timeout 60 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Time" -C 1 -q 2)

echo "  First time: $PREVIOUS_TIME"

echo ""
echo "Waiting for the device to run for a while..."
sleep 10

echo ""
echo "Querying the device for a line of data for a second time..."
mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Q/in" -m "1" -q 2

echo ""
echo "Giving the device time to receive the message..."
sleep 5

echo ""
echo "Getting the second time stamp from the device..."
TIME=$(timeout 60 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Time" -C 1 -q 2)

echo "  Latest time: $TIME"

# TODO: Remove if not needed. Should be obsolete
#DEVICE_TIME_FILE="devices/$DEVICE_NAME/time-last-published.txt"

#PREVIOUS_TIME=""
#if [ -f $DEVICE_TIME_FILE ]; then
#  PREVIOUS_TIME=$(cat $DEVICE_TIME_FILE)
#fi


if [ ! "$TIME" ] || [ "$TIME" = "$PREVIOUS_TIME" ]; then
  echo "  Latest MQTT data time hasn't been updated. Device is offline."  
  
  sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Offline" -r
  
  bash send-email.sh "$DEVICE_NAME on $HOST is offline" " The $DEVICE_NAME device on $HOST is offline.\n\nPrevious MQTT output time: $PREVIOUS_TIME\nLatest MQTT output time: $TIME\nMQTT Host: $MQTT_HOST"
else
  echo "  Device is online."
  
  sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Online" -r
  
  # TODO: Remove if not needed. Should be obsolete
  #echo $TIME > $DEVICE_TIME_FILE
fi

echo "Finished supervising device"
echo ""
