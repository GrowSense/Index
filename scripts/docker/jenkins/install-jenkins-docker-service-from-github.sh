SERVICE_FILE_URL="https://raw.githubusercontent.com/GreenSense/Index/master/scripts/docker/jenkins/greensense-jenkins-docker.service"

sudo wget $SERVICE_FILE_URL -O /lib/systemd/system/greensense-jenkins-docker.service

sudo chmod 644 /lib/systemd/system/greensense-jenkins-docker.service

sudo systemctl enable greensense-jenkins-docker.service
sudo systemctl restart greensense-jenkins-docker.service

echo "Finished installing service"
