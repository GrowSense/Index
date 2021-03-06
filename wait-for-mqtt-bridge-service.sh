echo "Waiting for MQTT bridge service to start..."

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "  Error: Please provide the device name as an argument."
  exit 1 
fi

if [ ! -d "devices/$DEVICE_NAME" ]; then
  echo "  Error: Device info not found '$DEVICE_NAME'."
  exit 1
fi

IS_FINISHED=0

MAX_LOOPS=20

CURRENT_LOOP=0

SLEEP_TIME=1

DEVICE_BOARD="$(cat devices/$DEVICE_NAME/board.txt)"

if [ "$DEVICE_BOARD" == "esp" ]; then
  echo "   ESP/WiFi device. Doesn't require MQTT bridge service. Skipping wait..."
  exit 0
fi

while [ $IS_FINISHED = 0 ]; do

  CURRENT_LOOP=$((CURRENT_LOOP+1))
  
  echo "  Loop: $CURRENT_LOOP"

  SERVICE_STATUS=$(bash view-mqtt-bridge-status.sh $DEVICE_NAME)

  echo "${SERVICE_STATUS}"

  [[ $(echo $SERVICE_STATUS) =~ "could not be found" ]] && echo "  Error: MQTT bridge service could not be found." && exit 1

  [[ $(echo $SERVICE_STATUS) =~ "inactive" ]] && echo "  Error: MQTT bridge service is inactive. Restarting..." && bash restart-garden-device.sh $DEVICE_NAME && exit 1

  [[ $(echo $SERVICE_STATUS) =~ "dead" ]] && echo "  Error: MQTT bridge service is dead. Restarting..." && bash restart-garden-device.sh $DEVICE_NAME && exit 1

  [[ $(echo $SERVICE_STATUS) =~ "D;" ]] && echo "MQTT bridge service is loaded" &&  IS_FINISHED=1

  [[ "$CURRENT_LOOP" == "$MAX_LOOPS" ]] && echo "  Error: Timed out waiting for service" && exit 1

  echo "  Is finished: $IS_FINISHED"
  echo ""
  
  [[ $IS_FINISHED = 0 ]] && echo "Sleeping for $SLEEP_TIME seconds..." && sleep $SLEEP_TIME
done

echo "Finished waiting for MQTT bridge service to start."
