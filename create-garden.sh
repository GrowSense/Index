DIR=$DIR

echo "Setting up mosquitto MQTT broker docker container"

cd scripts/docker/mosquitto/ && \
cp data/mosquitto.userfile.example data/mosquitto.userfile && \
sh install-mosquitto-docker-service.sh && \
cd $DIR && \

echo "Setup complete"
