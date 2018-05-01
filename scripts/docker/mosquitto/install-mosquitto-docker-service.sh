echo ""
echo "Setting up mosquitto MQTT broker docker service"
echo ""

DOCKER_SCRIPT="docker.sh"
SYSTEMCTL_SCRIPT="systemctl.sh"

echo "Pulling the mosquitto docker image"
sh $DOCKER_SCRIPT pull compulsivecoder/mosquitto-arm && \

echo "Creating /data/" && \
mkdir -p data && \

echo "Setting /data/ permissions" && \
sudo chmod 777 data && \

echo "Copying service file into systemd" && \
sudo cp -f greensense-mosquitto-docker.service /lib/systemd/system/greensense-mosquitto-docker.service && \
echo "Setting service permissions" && \
sudo chmod 644 /lib/systemd/system/greensense-mosquitto-docker.service && \

echo "Enabling service" && \
sudo sh $SYSTEMCTL_SCRIPT enable greensense-mosquitto-docker.service && \
echo "Starting/restarting service" && \
sudo sh $SYSTEMCTL_SCRIPT restart greensense-mosquitto-docker.service && \

echo "Install complete"
