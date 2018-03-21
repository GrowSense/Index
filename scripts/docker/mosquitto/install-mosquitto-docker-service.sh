mkdir -p data

sudo chmod 777 data

sudo cp -f greensense-mosquitto-docker.service /lib/systemd/system/greensense-mosquitto-docker.service
sudo chmod 644 /lib/systemd/system/greensense-mosquitto-docker.service

sudo systemctl daemon-reload
sudo systemctl enable greensense-mosquitto-docker.service
sudo systemctl restart greensense-mosquitto-docker.service

echo "Install complete"
