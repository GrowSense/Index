echo ""
echo "Setting up mosquitto MQTT broker docker service"
echo ""

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

DOCKER_SCRIPT="docker.sh"
SYSTEMCTL_SCRIPT="systemctl.sh"

echo "  Pulling the mosquitto docker image"
sh $DOCKER_SCRIPT pull compulsivecoder/mosquitto-arm || exit 1

MOSQUITTO_DIR="/usr/local/mosquitto"

if [ -f "is-mock-mqtt.txt" ]; then
  echo "Is mock MQTT"
  MOSQUITTO_DIR="mock/mosquitto"
fi

echo "Creating mosquitto dir..."
mkdir -p "$MOSQUITTO_DIR"

echo "mosquitto mqtt dir: $MOSQUITTO_DIR" && \

echo "  Creating /data/" && \
mkdir -p "$MOSQUITTO_DIR/data" && \

echo "  Setting /data/ permissions" && \
$SUDO chmod 777 $MOSQUITTO_DIR/data && \

SERVICE_FILE_PATH="scripts/docker/mosquitto/greensense-mosquitto-docker.service"

echo "Copying template file..."
cp $SERVICE_FILE_PATH.template $SERVICE_FILE_PATH

echo "Editing service file..."
sed -i "s/{BRANCH}/$BRANCH/g" $SERVICE_FILE_PATH && \

echo "Installing service file..." && \
bash install-service.sh $SERVICE_FILE_PATH && \

echo "Install complete"
