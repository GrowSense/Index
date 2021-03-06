echo "Waiting for UI controller service to start..."

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

  SERVICE_STATUS=$(bash view-ui-controller-1602-status.sh $DEVICE_NAME)

  echo "${SERVICE_STATUS}"

  [[ $(echo $SERVICE_STATUS) =~ "could not be found" ]] && echo "  Error: UI controller service could not be found." && exit 1

  [[ $(echo $SERVICE_STATUS) =~ "inactive" ]] && echo "  Error: UI controller service is inactive. Restarting..." && bash restart-garden-device.sh $DEVICE_NAME && exit 1

  [[ $(echo $SERVICE_STATUS) =~ "dead" ]] && echo "  Error: UI controller service is dead. Restarting..." && bash restart-garden-device.sh $DEVICE_NAME && exit 1

  [[ $(echo $SERVICE_STATUS) =~ "D;" ]] && echo "UI controller service is loaded" &&  IS_FINISHED=1

  [[ "$CURRENT_LOOP" == "$MAX_LOOPS" ]] && echo "  Error: Timed out waiting for service" && exit 1

  echo "  Is finished: $IS_FINISHED"
  echo ""
  
  [[ $IS_FINISHED = 0 ]] && echo "Sleeping for $SLEEP_TIME seconds..." && sleep $SLEEP_TIME
done

echo "Finished waiting for UI controller service to start."
