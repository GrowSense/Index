DIR=$DIR

# Set up mosquitto MQTT service
cd scripts/docker/mosquitto/
cp data/mosquitto.userfile.example data/mosquitto.userfile
sh install-mosquitto-docker-service.sh
cd $DIR

# Note: Edit the following file to set the mosquitto username and password:
# scripts/docker/mosquitto/data/mosquitto.userfile 

