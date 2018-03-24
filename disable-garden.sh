echo "Disabling moquitto MQTT service"
systemctl disable greensense-mosquitto-docker.service && \

echo "Stopping docker service"
docker stop mosquitto


