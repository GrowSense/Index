echo "Waiting for MQTT bridge service to start..."

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "  Error: Please provide the device name as an argument."
  exit 1 
fi

IS_FINISHED=0

MAX_LOOPS=20

CURRENT_LOOP=0

SLEEP_TIME=1

while [ $IS_FINISHED = 0 ]; do

  CURRENT_LOOP=$((CURRENT_LOOP+1))
  
  echo "  Loop: $CURRENT_LOOP"

  SERVICE_STATUS=$(bash view-mqtt-bridge-status.sh $DEVICE_NAME)

  echo "${SERVICE_STATUS}"

  [[ $(echo $SERVICE_STATUS) =~ "inactive" ]] && echo "MQTT bridge service is inactive. Restarting..." && bash restart-garden-device.sh $DEVICE_NAME && exit 1

  [[ $(echo $SERVICE_STATUS) =~ "dead" ]] && echo "MQTT bridge service is dead. Restarting..." && bash restart-garden-device.sh $DEVICE_NAME && exit 1

  [[ $(echo $SERVICE_STATUS) =~ "D;" ]] && echo "MQTT bridge service is loaded" &&  IS_FINISHED=1

  [[ "$CURRENT_LOOP" == "$MAX_LOOPS" ]] && echo "Timed out waiting for service" && exit 1

  echo "  Is finished: $IS_FINISHED"
  echo ""
  
  [[ $IS_FINISHED = 0 ]] && echo "Sleeping for $SLEEP_TIME seconds..." && sleep $SLEEP_TIME
done

echo "Finished waiting for MQTT bridge service to start."
