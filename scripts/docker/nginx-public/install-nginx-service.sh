sudo cp -f greensense-nginx-public-docker.service /lib/systemd/system/greensense-nginx-public-docker.service
sudo chmod 644 /lib/systemd/system/greensense-nginx-public-docker.service

sudo systemctl daemon-reload
sudo systemctl enable greensense-nginx-public-docker.service

echo "Reboot required"
#sudo reboot

