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
mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Q/in" -m "1"

CALIBRATED_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/C" -C 1)

if [ ! $CALIBRATED_VALUE ]; then
  echo "  Soil moisture: No MQTT data detected"  
else
  echo "  Soil moisture: $CALIBRATED_VALUE%"
fi

RAW_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/R" -C 1)

if [ ! $RAW_VALUE ]; then
  echo "  Soil moisture (raw): No MQTT data detected"  
else
  echo "  Soil moisture (raw): $RAW_VALUE"
fi

THRESHOLD_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/T" -C 1)

if [ ! $THRESHOLD_VALUE ]; then
  echo "  Threshold: No MQTT data detected"  
else
  echo "  Threshold: $THRESHOLD_VALUE%"
fi

PUMP_BURST_ON_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/B" -C 1)

if [ ! $PUMP_BURST_ON_VALUE ]; then
  echo "  Burst on: No MQTT data detected"
else
  echo "  Burst on: $PUMP_BURST_ON_VALUE seconds"
fi

PUMP_BURST_OFF_VALUE=$(timeout 10 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/O" -C 1)

if [ ! $PUMP_BURST_OFF_VALUE ]; then
  echo "  Burst off: No MQTT data detected"  
else
  echo "  Burst off: $PUMP_BURST_OFF_VALUE seconds"
fi

WET_CALIBRATION_VALUE=$(timeout 10 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/W" -C 1)

if [ ! $WET_CALIBRATION_VALUE ]; then
  echo "  Wet (calibration): No MQTT data detected"
else
  echo "  Wet (calibration): $WET_CALIBRATION_VALUE"
fi

DRY_CALIBRATION_VALUE=$(timeout 10 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/D" -C 1)

if [ ! $DRY_CALIBRATION_VALUE ]; then
  echo "  Dry (calibration): No MQTT data detected"  
else
  echo "  Dry (calibration): $DRY_CALIBRATION_VALUE"
fi
