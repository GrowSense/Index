DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

echo "  MQTT Data ($MQTT_HOST)"

CALIBRATED_VALUE=$(timeout 10 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/C" -C 1)

if [ ! $CALIBRATED_VALUE ]; then
  echo "    No MQTT data detected"  
else
  echo "    Soil moisture: $CALIBRATED_VALUE%"
fi

#RAW_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/R" -C 1)

#echo "    Raw: $RAW_VALUE"

#DRY_CALIBRATION_VALUE=$(mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/D" -C 1)

#echo "    Dry (calibration): $DRY_CALIBRATION_VALUE"

#WET_CALIBRATION_VALUE=$(mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/W" -C 1)

#echo "    Wet (calibration): $WET_CALIBRATION_VALUE"
