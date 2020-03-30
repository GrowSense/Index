MAX_LOOPS=50

if [ ! "$LOOP_NUMBER" ]; then
  LOOP_NUMBER=1
fi

MOSQUITTO_DIR="/usr/local/mosquitto"

#docker pull compulsivecoder/mosquitto-arm

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  SUDO='sudo'
fi

didSucceed=0;
loopNumber=1

while [ "$didSucceed" -eq "0" ] && [ "$loopNumber" -lt "$MAX_LOOPS" ]; do
  echo "Running mosquitto docker container..."
  echo "  Loop number $loopNumber"

  docker pull compulsivecoder/mosquitto-arm && didSucceed=1 || didSucceed=0

  if [ "$didSucceed" == "1" ]; then
    docker run -d \
      --restart=always \
      --name=mosquitto \
	  --volume $MOSQUITTO_DIR/data:/mosquitto_data \
	  -e MQTT_HOST=localhost \
	  -e MQTT_CLIENTID=client1234 \
	  -e MQTT_USERNAME=j \
	  -e MQTT_PASSWORD=pass \
	  -e MQTT_TOPIC=Test \
	  -p 1883:1883 \
	  -p 8080:8080 \
	  compulsivecoder/mosquitto-arm && didSucceed=1 || didSucceed=0
  fi

  if [ "$didSucceed" == "0" ]; then
    echo "Error: Failed to start mosquitto docker container"
    if [[ "$LOOP_NUMBER" -lt "$MAX_LOOPS" ]]; then
      echo "  Restarting docker service..."
      $SUDO service docker restart
      loopNumber=$(($loopNumber+1))
      docker stop mosquitto
      docker rm mosquitto
    fi
  fi
done
