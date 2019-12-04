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
if [ ! -f "is-mock-mqtt.txt" ]; then
  sh $DOCKER_SCRIPT pull compulsivecoder/mosquitto-arm || exit 1
else
  echo "[mock] sh $DOCKER_SCRIPT pull compulsivecoder/mosquitto-arm"
fi

MOSQUITTO_INSTALL_DIR="/usr/local/mosquitto"

if [ -f "is-mock-mqtt.txt" ]; then
  echo "  Is mock MQTT"
  MOSQUITTO_INSTALL_DIR="mock/mosquitto"
fi

echo ""
echo "  Creating mosquitto install dir..."
echo "    $MOSQUITTO_INSTALL_DIR"
$SUDO mkdir -p "$MOSQUITTO_INSTALL_DIR" || exit 1

echo ""
echo "  Creating $MOSQUITTO_INSTALL_DIR/data/"
$SUDO mkdir -p "$MOSQUITTO_INSTALL_DIR/data" || exit 1

echo ""
echo "  Creating $MOSQUITTO_INSTALL_DIR/data/mosquitto.userfile"
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
CREDENTIALS_FILE="$MOSQUITTO_INSTALL_DIR/data/mosquitto.userfile"
$SUDO echo "$MQTT_USERNAME:$MQTT_PASSWORD" > $CREDENTIALS_FILE || exit 1

echo ""
echo "  Setting $MOSQUITTO_INSTALL_DIR/data/ permissions"
$SUDO chmod 777 $MOSQUITTO_INSTALL_DIR/data || exit 1

INTERNAL_MOSQUITTO_DIRECTORY="scripts/docker/mosquitto"

#SERVICE_FILE_PATH="$INTERNAL_MOSQUITTO_DIRECTORY/growsense-mosquitto-docker.service"

#echo ""
#echo "  Copying run script into install dir..."
#START_SCRIPT_NAME="run-mosquitto-arm.sh"
START_SCRIPT_PATH="$INTERNAL_MOSQUITTO_DIRECTORY/$START_SCRIPT_NAME"
#$SUDO cp -f $START_SCRIPT_PATH "$MOSQUITTO_INSTALL_DIR/$START_SCRIPT_NAME" || exit 1

#echo ""
#echo "  Copying template file..."
#cp $SERVICE_FILE_PATH.template $SERVICE_FILE_PATH || exit 1

#echo ""
#echo "  Editing service file..."
#sed -i "s/{BRANCH}/$BRANCH/g" $SERVICE_FILE_PATH || exit 1

#echo ""
#echo "  Installing service file..."
#bash install-service.sh $SERVICE_FILE_PATH || exit 1

if [ ! -f "is-mock-mqtt.txt" ] && [ ! -f "is-mock-docker.txt" ]; then
        echo ""
        echo "  Starting mosquitto MQTT docker container..."
        bash $START_SCRIPT_PATH || exit 1

	echo ""
	echo "  Waiting for docker container to start..."
	bash wait-for-mqtt-service.sh || exit 1

#	echo ""
#	echo "  Checking mosquitto docker container started..."
#	DOCKER_PS_RESULT="$(docker ps)"

#	if [[ $(echo $DOCKER_PS_RESULT) =~ "Cannot connect to the Docker daemon" ]]; then
#	  echo "Error: Docker service isn't running"
#	  exit 1
#	fi

#	if [[ ! $(echo $DOCKER_PS_RESULT) =~ "mosquitto" ]]; then
#	  echo "Error: mosquitto docker container isn't running"
#	  exit 1
#	fi
fi

echo ""
echo "Finished installing mosquitto docker service"
