# Install docker if not found
if ! type "docker" > /dev/null; then
  DOCKER_INSTALL_SCRIPT="https://raw.githubusercontent.com/GrowSense/Index/master/scripts/install/install-docker.sh"
  sudo wget -O - $DOCKER_INSTALL_SCRIPT | sh -s
fi

# Install jenkins service file
SERVICE_FILE_URL="https://raw.githubusercontent.com/GrowSense/Index/master/scripts/docker/jenkins/growsense-jenkins-docker-4.service"

sudo wget $SERVICE_FILE_URL -O /lib/systemd/system/growsense-jenkins-docker.service

sudo chmod 644 /lib/systemd/system/growsense-jenkins-docker.service

sudo systemctl enable growsense-jenkins-docker.service
sudo systemctl restart growsense-jenkins-docker.service

echo "Finished installing service"
