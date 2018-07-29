DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Provided a device name as an argument."
  exit 1
fi

OUTPUT=$(sh view-mqtt-bridge-status.sh $DEVICE_NAME)

RESULT="NotSet"

case "$OUTPUT" in 
  *inactive*)
    RESULT="Inactive"
    ;;
  *active*)
    RESULT="Active"
    ;;
esac

#echo $OUTPUT

echo "  MQTT Bridge Service: $RESULT"

OUTPUT=$(sh view-updater-status.sh $DEVICE_NAME)

RESULT="NotSet"

case "$OUTPUT" in 
  *inactive*)
    RESULT="Inactive"
    ;;
  *active*)
    RESULT="Active"
    ;;
esac

#echo $OUTPUT

echo "  Updater Service: $RESULT"
