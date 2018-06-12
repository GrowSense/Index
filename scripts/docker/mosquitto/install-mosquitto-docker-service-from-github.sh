# Install docker if not found
if ! type "docker" > /dev/null; then
  DOCKER_INSTALL_SCRIPT="https://raw.githubusercontent.com/GreenSense/Index/master/scripts/install/install-docker.sh"
  sudo wget -O - $DOCKER_INSTALL_SCRIPT | sh -s
fi

# Install jenkins service file
SERVICE_FILE_URL="https://raw.githubusercontent.com/GreenSense/Index/master/scripts/docker/mosquitto/greensense-mosquitto-docker.service"

sudo wget $SERVICE_FILE_URL -O /lib/systemd/system/greensense-mosquitto-docker.service

sudo chmod 644 /lib/systemd/system/greensense-mosquitto-docker.service

sudo systemctl enable greensense-mosquitto-docker.service
sudo systemctl restart greensense-mosquitto-docker.service

echo "Finished installing service"
