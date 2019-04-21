echo ""
echo "Setting up mosquitto MQTT broker docker service"
echo ""

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

DOCKER_SCRIPT="docker.sh"
SYSTEMCTL_SCRIPT="systemctl.sh"

echo "  Pulling the mosquitto docker image"
sh $DOCKER_SCRIPT pull compulsivecoder/mosquitto-arm || exit 1

MOSQUITTO_DIR="/usr/local/mosquitto" && \

echo "mosquitto mqtt dir: $MOSQUITTO_DIR" && \

echo "  Creating /data/" && \
mkdir -p "$MOSQUITTO_DIR/data" && \

echo "  Setting /data/ permissions" && \

$SUDO chmod 777 $MOSQUITTO_DIR/data && \

echo "  Installing service file" && \
sh install-service.sh $MOSQUITTO_DIR/greensense-mosquitto-docker.service && \

echo "Install complete"
