sudo cp -f growsense-jenkins-docker.service /lib/systemd/system/growsense-jenkins-docker.service
sudo chmod 644 /lib/systemd/system/growsense-jenkins-docker.service

#sudo systemctl daemon-reload
sudo systemctl enable growsense-jenkins-docker.service
sudo systemctl restart growsense-jenkins-docker.service

echo "Finished installing service"
