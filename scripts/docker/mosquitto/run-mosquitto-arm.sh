
docker run -d \
  --rm \
  --name=mosquitto \
	--volume $PWD/data:/mosquitto_data \
	-e MQTT_HOST=localhost \
	-e MQTT_CLIENTID=client1234 \
	-e MQTT_USERNAME=j \
	-e MQTT_PASSWORD=pass \
	-e MQTT_TOPIC=Test \
	-p 1883:1883 \
	compulsivecoder/mosquitto-arm
