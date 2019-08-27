echo "Disabling moquitto MQTT service"
sudo sh systemctl.sh stop greensense-mosquitto-docker.service && \
sudo sh systemctl.sh disable greensense-mosquitto-docker.service && \

echo "Stopping docker service"
sh docker.sh stop mosquitto


