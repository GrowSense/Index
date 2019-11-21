DEVICE_NAME=$1

EXAMPLE="Example:\n\tsh supervise-irrigator-device.sh [DeviceName]"

#echo "Supervising garden irrigator device..."

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  echo $EXAMPLE
  exit 1
fi

#echo "  Device name: $DEVICE_NAME"

if [ ! -d "devices/$DEVICE_NAME" ]; then
  echo "  Error: Device $DEVICE_NAME not found."
  exit 1
fi

DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt");

CURRENT_HOST=$(cat "/etc/hostname")
DEVICE_HOST=$(cat "devices/$DEVICE_NAME/host.txt")

if [ "$DEVICE_HOST" = "$CURRENT_HOST" ]; then

  MQTT_HOST=$(cat mqtt-host.security)
  MQTT_USERNAME=$(cat mqtt-username.security)
  MQTT_PASSWORD=$(cat mqtt-password.security)
  MQTT_PORT=$(cat mqtt-port.security)

  HOST=$(cat /etc/hostname)

  echo ""
  echo "Querying the device for a line of data..."
  mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/Q/in" -m "1" -q 2

  echo ""
  echo "Getting the threshold from the device..."
  THRESHOLD=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/T" -C 1 -q 2)

  echo "Threshold: $THRESHOLD"

  # Disabled. Only used for manual testing.
  #THRESHOLD="50"

  echo ""
  echo "Getting the calibrated soil moisture value from the device..."
  CALIBRATED_SOIL_MOISTURE_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/C" -C 1 -q 2)

  # Disabled. Only used for manual testing.
  #CALIBRATED_SOIL_MOISTURE_VALUE="30"

  echo "Soil Moisture: $CALIBRATED_SOIL_MOISTURE_VALUE%"

  if [ -f "devices/$DEVICE_NAME/is-soil-moisture-low.txt" ]; then
    WAS_SOIL_MOISTURE_LOW=$(cat "devices/$DEVICE_NAME/is-soil-moisture-low.txt")
  else
    WAS_SOIL_MOISTURE_LOW="0"
  fi

  if [ "$CALIBRATED_SOIL_MOISTURE_VALUE" -lt "$THRESHOLD" ]; then
    echo "  Soil moisture is below threshold."

    # If the soil moisture wasn't previously low then report that it is
    if [ "$WAS_SOIL_MOISTURE_LOW" = "0" ]; then
      sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Low Moisture" -r
  
      bash send-email.sh "Error: $DEVICE_NAME (on $DEVICE_HOST) has low soil moisture" "Soil moisture $DEVICE_NAME device (on $DEVICE_HOST) is low. The device may be malfunctioning.\n\nThreshold: $THRESHOLD\nSoil Moisture: $CALIBRATED_SOIL_MOISTURE_VALUE"

      bash create-alert-file.sh "$DEVICE_NAME (on $DEVICE_HOST) has low soil moisture. Device may be malfunctioning."

      bash restart-garden-device.sh $DEVICE_NAME
  
      echo "1" > "devices/$DEVICE_NAME/is-soil-moisture-low.txt"
    else
      echo "  Error reports have already been sent. Skipping send."
    fi
  else
    echo "  Soil moisture is above threshold."
  
    echo "  Was device soil moisture low: $WAS_SOIL_MOISTURE_LOW"
  
    sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Working" -r
  
    # If the soil moisture was previously low report that it's back above threshold
    if [ "$WAS_SOIL_MOISTURE_LOW" = "1" ]; then
      echo "  Soil moisture is back above threshold again."

      echo "  Sending soil moisture back above threshold email report..."
      bash send-email.sh "$DEVICE_NAME (on $DEVICE_HOST) soil moisture is back above threshold" "Soil moisture for $DEVICE_NAME device (on $DEVICE_HOST) is back above threshold.\n\nThreshold: $THRESHOLD\nSoil Moisture: $CALIBRATED_SOIL_MOISTURE_VALUE"

      bash create-message-file.sh "$DEVICE_NAME  (on $DEVICE_HOST) soil moisture is back above threshold"
    fi
  
    echo "0" > "devices/$DEVICE_NAME/is-soil-moisture-low.txt"
  fi

else
 echo "  Device is on another host. Skipping status check."
fi

#echo "Finished supervising garden irrigator device."