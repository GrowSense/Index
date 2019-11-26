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
mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/Q/in" -m "1"

CALIBRATED_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/L" -C 1)

if [ ! $CALIBRATED_VALUE ]; then
  echo "  Light: No MQTT light data detected"  
else
  echo "  Light: $CALIBRATED_VALUE%"
fi

RAW_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/R" -C 1)

if [ ! $RAW_VALUE ]; then
  echo "  Light (raw): No MQTT light data detected"  
else
  echo "  Light (raw): $RAW_VALUE%"
fi

MODE_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/M" -C 1)

if [ ! "$MODE_VALUE" ]; then
  echo "  Mode: No MQTT mode data detected"  
else
  [[ "$MODE_VALUE" = "0" ]] && MODE_TEXT="Off"
  [[ "$MODE_VALUE" = "1" ]] && MODE_TEXT="On"
  [[ "$MODE_VALUE" = "2" ]] && MODE_TEXT="Timer"
  [[ "$MODE_VALUE" = "3" ]] && MODE_TEXT="On Above Threshold"
  [[ "$MODE_VALUE" = "4" ]] && MODE_TEXT="On Below Threshold"
#  [[ "$MODE_VALUE" = "5" ]] && MODE_TEXT="Fade" # Disabled. Not yet supported
#  [[ "$MODE_VALUE" = "6" ]] && MODE_TEXT="Supplement" # Disabled. Not yet supported
  echo "  Mode: $MODE_TEXT"
fi

CLOCK_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/C" -C 1)

if [ ! "$CLOCK_VALUE" ]; then
  echo "  Clock: No MQTT clock data detected"  
else
  echo "  Clock: $CLOCK_VALUE"
fi

START_HOUR_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/E" -C 1)
START_MINUTE_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/F" -C 1)

if [ ! "$START_HOUR_VALUE" ]; then
  echo "  Timer start: No MQTT data detected"  
else
  echo "  Timer start: $START_HOUR_VALUE:$START_MINUTE_VALUE"
fi

STOP_HOUR_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/G" -C 1)
STOP_MINUTE_VALUE=$(timeout 5 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "$DEVICE_NAME/H" -C 1)

if [ ! "$STOP_HOUR_VALUE" ]; then
  echo "  Timer stop: No MQTT data detected"  
else
  echo "  Timer stop: $STOP_HOUR_VALUE:$STOP_MINUTE_VALUE"
fi
