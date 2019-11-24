echo "Waiting for mosquitto MQTT service/docker container to start..."

IS_FINISHED=0

MAX_LOOPS=20

CURRENT_LOOP=0

SLEEP_TIME=1

while [ $IS_FINISHED = 0 ]; do

  CURRENT_LOOP=$((CURRENT_LOOP+1))
  
  echo "  Loop: $CURRENT_LOOP"

  DOCKER_PS_RESULT=$(docker ps)

  echo "${DOCKER_PS_RESULT}"

  [[ $(echo $DOCKER_PS_RESULT) =~ "Cannot connect to the Docker daemon" ]] && echo "Error: Cannot connect to docker daemon" && exit 1

  [[ $(echo $DOCKER_PS_RESULT) =~ "mosquitto" ]] && echo "  Mosquitto MQTT service/docker container found" && IS_FINISHED=1

  [[ "$CURRENT_LOOP" == "$MAX_LOOPS" ]] && echo "  Reached the max number of loops" && echo "  Error: Mosquitto MQTT service/docker container failed to start" && exit 1

  echo "  Is finished: $IS_FINISHED"
  echo ""
  
  [[ $IS_FINISHED = 0 ]] && echo "Sleeping for $SLEEP_TIME seconds..." && sleep $SLEEP_TIME
done

echo "Finished waiting for mosquitto MQTT service/docker container to start."
