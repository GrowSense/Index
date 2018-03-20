sudo cp -f greensense-mosquitto-docker.service /lib/systemd/system/greensense-mosquitto-docker.service
sudo chmod 644 /lib/systemd/system/greensense-mosquitto-docker.service

sudo systemctl daemon-reload
sudo systemctl enable greensense-mosquitto-docker.service
sudo systemctl start greensense-mosquitto-docker.service


echo "Reboot required"
#sudo reboot

