sudo cp -f growsense-nginx-public-docker.service /lib/systemd/system/growsense-nginx-public-docker.service
sudo chmod 644 /lib/systemd/system/growsense-nginx-public-docker.service

sudo systemctl daemon-reload
sudo systemctl enable growsense-nginx-public-docker.service

echo "Reboot required"
#sudo reboot

