sudo cp -f greensense-jenkins-docker.service /lib/systemd/system/greensense-jenkins-docker.service
sudo chmod 644 /lib/systemd/system/greensense-jenkins-docker.service

sudo systemctl daemon-reload
sudo systemctl enable greensense-jenkins-docker.service

echo "Reboot required"
#sudo reboot

