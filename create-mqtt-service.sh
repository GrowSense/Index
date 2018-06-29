echo ""
echo "Setting up mosquitto MQTT broker docker service"
echo ""

DOCKER_SCRIPT="docker.sh"
SYSTEMCTL_SCRIPT="systemctl.sh"

echo "  Pulling the mosquitto docker image"
sh $DOCKER_SCRIPT pull compulsivecoder/mosquitto-arm || exit 1

MOSQUITTO_DIR="scripts/docker/mosquitto" && \

echo "mosquitto mqtt dir: $MOSQUITTO_DIR" && \

echo "  Creating /data/" && \
mkdir -p "$MOSQUITTO_DIR/data" && \

echo "  Setting /data/ permissions" && \

chmod 777 $MOSQUITTO_DIR/data && \

echo "  Installing service file" && \
sh install-service.sh $MOSQUITTO_DIR/greensense-mosquitto-docker.service && \

echo "Install complete"
