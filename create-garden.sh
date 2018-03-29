DIR=$DIR

echo ""
echo "Setting up mosquitto MQTT broker docker container"
echo ""

cd scripts/docker/mosquitto/ && \

USER_FILE="data/mosquitto.userfile"

if [ -f $USER_FILE ]; then
  cp data/mosquitto.userfile.example data/mosquitto.userfile && \
  sh install-mosquitto-docker-service.sh || exit 1
else
  echo ""
  echo "Error: No mosquitto.userfile found. Run the following command to create it:"
  echo "  sh set-mqtt-credentials.sh [username] [password]"
  echo ""
  exit 1
fi

cd $DIR

echo ""
echo "Setup complete"
echo ""
