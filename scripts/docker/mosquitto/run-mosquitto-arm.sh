#docker stop mosquitto || echo "Skipping stop"
#docker rm mosquitto || echo "Skipping remove" 

LOOP_NUMBER=$1

MAX_LOOPS=5

if [ ! "$LOOP_NUMBER" ]; then
  LOOP_NUMBER=1
fi

MOSQUITTO_DIR="/usr/local/mosquitto"

#docker pull compulsivecoder/mosquitto-arm

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  SUDO='sudo'
fi

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
	compulsivecoder/mosquitto-arm || (echo "Error: Failed to start mosquitto docker container" && [[ "$LOOP_NUMBER" -lt "$MAX_LOOPS" ]] && echo "  Retrying..." && $SUDO service docker restart && bash run-mosquitto-arm.sh $(($LOOP_NUMBER+1)))
