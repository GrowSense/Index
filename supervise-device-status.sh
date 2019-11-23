DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

if [ ! -d "devices/$DEVICE_NAME" ]; then
  echo "  Error: Device $DEVICE_NAME not found."
  exit 1
fi

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

HOST=$(cat /etc/hostname)

echo ""
echo "Querying the device for a line of data..."
mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/Q/in" -m "1" -q 2

echo ""
echo "Giving the device time to receive the message..."
sleep 10
#sleep 10

echo ""
echo "Getting the time stamp from the device..."
PREVIOUS_TIME=$(timeout 60 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/Time" -C 1 -q 2)

echo "  First time: $PREVIOUS_TIME"

echo ""
echo "Waiting for the device to run for a while..."
sleep 20
#sleep 100

echo ""
echo "Querying the device for a line of data for a second time..."
mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/Q/in" -m "1" -q 2

echo ""
echo "Giving the device time to receive the message..."
sleep 10
#sleep 20

echo ""
echo "Getting the second time stamp from the device..."
TIME=$(timeout 60 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/Time" -C 1 -q 2)

echo "  Latest time: $TIME"

# TODO: Remove if not needed. Should be obsolete
#DEVICE_TIME_FILE="devices/$DEVICE_NAME/time-last-published.txt"

#PREVIOUS_TIME=""
#if [ -f $DEVICE_TIME_FILE ]; then
#  PREVIOUS_TIME=$(cat $DEVICE_TIME_FILE)
#fi

if [ -f "devices/$DEVICE_NAME/is-device-offline.txt" ]; then
  WAS_DEVICE_OFFLINE=$(cat "devices/$DEVICE_NAME/is-device-offline.txt")
else
  WAS_DEVICE_OFFLINE="0"
fi
  

if [ ! "$TIME" ] || [ "$TIME" = "$PREVIOUS_TIME" ]; then
  echo "  Latest MQTT data time hasn't been updated. Device is offline."  
  
  # If the device was previously online then report that it's now offline
  if [ "$WAS_DEVICE_OFFLINE" = "0" ]; then
    sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Offline" -r
  
    bash send-email.sh "Error: $DEVICE_NAME on $HOST is offline" "The $DEVICE_NAME device on $HOST is offline.\n\nPrevious MQTT output time: $PREVIOUS_TIME\nLatest MQTT output time: $TIME\nMQTT Host: $MQTT_HOST"

    bash create-alert-file.sh "$DEVICE_NAME  on $HOST is offline"

    bash restart-garden-device.sh $DEVICE_NAME
  
    echo "1" > "devices/$DEVICE_NAME/is-device-offline.txt"
  fi
else
  echo "  Device is online."
  
  echo "  Was device offline: $WAS_DEVICE_OFFLINE"
  
  sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Online" -r
  
  # If the device was previously offline then report that it's back online
  if [ "$WAS_DEVICE_OFFLINE" = "1" ]; then
    echo "  Sending device back online email report..."
    bash send-email.sh "$DEVICE_NAME on $HOST is back online" "The $DEVICE_NAME device on $HOST is back online.\n\nPrevious MQTT output time: $PREVIOUS_TIME\nLatest MQTT output time: $TIME\nMQTT Host: $MQTT_HOST"

    bash create-message-file.sh "$DEVICE_NAME  on $HOST is back online"
  fi
  
  echo "0" > "devices/$DEVICE_NAME/is-device-offline.txt"
  
  # TODO: Remove if not needed. Should be obsolete
  #echo $TIME > $DEVICE_TIME_FILE
fi

echo "Finished supervising device"
echo ""
