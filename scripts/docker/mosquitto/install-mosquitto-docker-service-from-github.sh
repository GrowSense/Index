USERNAME=$1
PASSWORD=$2

ARGUMENTS_ERROR_MESSAGE="Please specify the MQTT username and password as arguments."

if [ ! "$USERNAME" ]; then
  echo $ARGUMENTS_ERROR_MESSAGE
  exit 1 
fi

if [ ! "$PASSWORD" ]; then
  echo $ARGUMENTS_ERROR_MESSAGE
  exit 1 
fi

# Install docker if not found
if ! type "docker" > /dev/null; then
  echo "  Installing docker"
  
  DOCKER_INSTALL_SCRIPT="https://raw.githubusercontent.com/GrowSense/Index/master/scripts/install/install-docker.sh"
  sudo wget -O - $DOCKER_INSTALL_SCRIPT | bash -s || exit 1
fi

echo "  Pulling mosquitto docker container..."
docker pull eclipse-mosquitto

echo "  Creating mosquitto directory..."

MOSQUITTO_DIR="/usr/local/mosquitto"
DATA_DIR="$MOSQUITTO_DIR/data"
CREDENTIALS_FILE="$DATA_DIR/mosquitto.userfile"

sudo mkdir -p $MOSQUITTO_DIR && \
sudo mkdir -p $DATA_DIR && \
sudo chmod 777 $DATA_DIR && \

echo "  Creating credentials file" && \

echo "$USERNAME:$PASSWORD" > $CREDENTIALS_FILE && \

echo "  Installing mosquitto start script..."

START_SCRIPT_URL="https://raw.githubusercontent.com/GrowSense/Index/master/scripts/docker/mosquitto/run-mosquitto-arm.sh"

sudo wget $START_SCRIPT_URL -O "$MOSQUITTO_DIR/run-mosquitto-arm.sh"

sudo bash $MOSQUITTO_DIR/run-mosquitto-arm.sh

# TODO: Clean up. MQTT systemctl service is obsolete. Using docker only.
#echo "  Installing mosquitto service file..."

#SERVICE_FILE_URL="https://raw.githubusercontent.com/GrowSense/Index/master/scripts/docker/mosquitto/growsense-mosquitto-docker.service"

#sudo wget $SERVICE_FILE_URL -O /lib/systemd/system/growsense-mosquitto-docker.service

#sudo chmod 644 /lib/systemd/system/growsense-mosquitto-docker.service

#sudo systemctl enable growsense-mosquitto-docker.service
#sudo systemctl restart growsense-mosquitto-docker.service

echo "Finished installing service"
