echo ""
echo "Setting up mosquitto MQTT broker docker service"
echo ""

echo "Creating /data/" && \
mkdir -p data && \

echo "Setting /data/ permissions" && \
sudo chmod 777 data && \

echo "Copying service file into systemd" && \
sudo cp -f greensense-mosquitto-docker.service /lib/systemd/system/greensense-mosquitto-docker.service && \
echo "Setting service permissions" && \
sudo chmod 644 /lib/systemd/system/greensense-mosquitto-docker.service && \

#sudo systemctl daemon-reload && \
echo "Enabling service" && \
sudo systemctl enable greensense-mosquitto-docker.service && \
echo "Starting/restarting service" && \
sudo systemctl restart greensense-mosquitto-docker.service && \

echo "Install complete"
