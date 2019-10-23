echo ""
echo "Upgrading mosquitto MQTT broker docker service..."
echo ""

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

DOCKER_SCRIPT="docker.sh"
SYSTEMCTL_SCRIPT="systemctl.sh"

MOSQUITTO_SERVICE="growsense-mosquitto-docker.service"

echo ""
echo "  Stopping the mosquitto docker service..."
$SUDO bash $SYSTEMCTL_SCRIPT stop $MOSQUITTO_SERVICE || exit 1

echo ""
echo "  Pulling the mosquitto docker image..."
sh $DOCKER_SCRIPT pull compulsivecoder/mosquitto-arm || exit 1

echo ""
echo "  Stopping the docker container..."
sh $DOCKER_SCRIPT stop mosquitto || exit 1

echo ""
echo "  Removing the docker container..."
sh $DOCKER_SCRIPT rm mosquitto || exit 1

echo ""
echo "  Recreating the MQTT service..."
bash create-mqtt-service.sh

echo ""
echo "Finished upgrading mosquitto docker service."
