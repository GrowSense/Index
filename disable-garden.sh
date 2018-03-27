echo "Disabling moquitto MQTT service"
sudo systemctl disable greensense-mosquitto-docker.service && \

echo "Stopping docker service"
docker stop mosquitto


