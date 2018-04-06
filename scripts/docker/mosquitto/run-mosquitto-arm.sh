docker stop mosquitto || echo "Skipping stop"
docker rm mosquitto || echo "Skipping remove" 

docker run -d \
  --restart=always \
  --name=mosquitto \
	--volume $PWD/data:/mosquitto_data \
	-e MQTT_HOST=localhost \
	-e MQTT_CLIENTID=client1234 \
	-e MQTT_USERNAME=j \
	-e MQTT_PASSWORD=pass \
	-e MQTT_TOPIC=Test \
	-p 1883:1883 \
	-p 8080:8080 \
	compulsivecoder/mosquitto-arm
