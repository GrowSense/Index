# TODO: Clean up. MQTT systemctl service is obsolete. Using docker only.
echo "Disabling moquitto MQTT service"
sudo sh systemctl.sh stop growsense-mosquitto-docker.service && \
sudo sh systemctl.sh disable growsense-mosquitto-docker.service && \

echo "Stopping docker service"
sh docker.sh stop mosquitto


