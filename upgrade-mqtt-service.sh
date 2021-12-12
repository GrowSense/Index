echo ""
echo "Upgrading mosquitto MQTT broker docker service..."
echo ""

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

DOCKER_SCRIPT="docker.sh"

# TODO: Clean up. MQTT systemctl service is obsolete. Using docker only.
#SYSTEMCTL_SCRIPT="systemctl.sh"

#MOSQUITTO_SERVICE="growsense-mosquitto-docker.service"

echo ""
echo "  Pulling the mosquitto docker image..."
PULL_RESULT=$(sh $DOCKER_SCRIPT pull eclipse-mosquitto) || exit 1

echo ${PULL_RESULT}

if [[ ! $(echo $PULL_RESULT) =~ "Image is up to date" ]]; then
  echo "  Newer docker image found. Updating."

  echo ""
  echo "  Stopping the mosquitto docker service..."
  $SUDO bash $SYSTEMCTL_SCRIPT stop $MOSQUITTO_SERVICE || exit 1

  echo ""
  echo "  Stopping the docker container..."
  sh $DOCKER_SCRIPT stop mosquitto || exit 1

  echo ""
  echo "  Removing the docker container..."
  sh $DOCKER_SCRIPT rm mosquitto || exit 1

  echo ""
  echo "  Recreating the MQTT service..."
  bash create-mqtt-service.sh
else
  echo "  Docker image is up to date."
fi

echo ""
echo "Finished upgrading mosquitto docker service."
