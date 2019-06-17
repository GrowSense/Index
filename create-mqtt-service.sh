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

echo ""
echo "  Pulling the mosquitto docker image"
sh $DOCKER_SCRIPT pull compulsivecoder/mosquitto-arm || exit 1

MOSQUITTO_INSTALL_DIR="/usr/local/mosquitto"

if [ -f "is-mock-mqtt.txt" ]; then
  echo "  Is mock MQTT"
  MOSQUITTO_INSTALL_DIR="mock/mosquitto"
fi

echo ""
echo "  Creating mosquitto install dir..."
echo "    $MOSQUITTO_INSTALL_DIR"
$SUDO mkdir -p "$MOSQUITTO_INSTALL_DIR"

echo ""
echo "  Creating /data/" && \
$SUDO mkdir -p "$MOSQUITTO_INSTALL_DIR/data" && \

echo ""
echo "  Setting /data/ permissions" && \
$SUDO chmod 777 $MOSQUITTO_INSTALL_DIR/data && \

INTERNAL_MOSQUITTO_DIRECTORY="scripts/docker/mosquitto"

SERVICE_FILE_PATH="$INTERNAL_MOSQUITTO_DIRECTORY/greensense-mosquitto-docker.service"

echo ""
echo "  Copying run script into install dir..."
START_SCRIPT_NAME="run-mosquitto-arm.sh"
START_SCRIPT_PATH="$INTERNAL_MOSQUITTO_DIRECTORY/$START_SCRIPT_NAME"
sudo cp -f $START_SCRIPT_PATH "$MOSQUITTO_INSTALL_DIR/$START_SCRIPT_NAME" || exit 1

echo ""
echo "  Copying template file..."
cp $SERVICE_FILE_PATH.template $SERVICE_FILE_PATH

echo ""
echo "  Editing service file..."
sed -i "s/{BRANCH}/$BRANCH/g" $SERVICE_FILE_PATH && \

echo ""
echo "  Installing service file..." && \
bash install-service.sh $SERVICE_FILE_PATH && \

echo "Install complete"
