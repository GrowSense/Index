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

echo ""
echo "Setting up mosquitto MQTT broker docker service"
echo ""

DOCKER_SCRIPT="docker.sh"
SYSTEMCTL_SCRIPT="systemctl.sh"

echo "Pulling the mosquitto docker image"
sh $DOCKER_SCRIPT pull compulsivecoder/mosquitto-arm && \

echo "Creating mosquitto directory"

MOSQUITTO_DIR="/usr/local/mosquitto"
DATA_DIR="$MOSQUITTO_DIR/data"
CREDENTIALS_FILE="$DATA_DIR/mosquitto.userfile"

sudo mkdir -p $MOSQUITTO_DIR && \
sudo mkdir -p $DATA_DIR && \
sudo chmod 777 $DATA_DIR && \

echo "Creating credentials file" && \

echo "$USERNAME:$PASSWORD" > $CREDENTIALS_FILE && \

echo "Copying service file into systemd" && \
sudo cp -f greensense-mosquitto-docker.service /lib/systemd/system/greensense-mosquitto-docker.service && \
echo "Setting service permissions" && \
sudo chmod 644 /lib/systemd/system/greensense-mosquitto-docker.service && \

echo "Enabling service" && \
sudo sh $SYSTEMCTL_SCRIPT enable greensense-mosquitto-docker.service && \
echo "Starting/restarting service" && \
sudo sh $SYSTEMCTL_SCRIPT restart greensense-mosquitto-docker.service && \

echo "Install complete"
