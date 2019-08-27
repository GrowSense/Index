DIR=$PWD

echo "Exposing Linear MQTT Dashboard config file via HTTP..."

# Only launch it if docker is enabled
if [ ! -f "is-mock-docker.txt" ]; then

  cd scripts/docker/nginx

  sh start-linear-mqtt-config-http.sh

  echo ""
  echo "  Waiting for docker container to start..."
  sleep 3

  echo ""
  echo "  Checking greensense-ui-http docker container started..."
  DOCKER_PS_RESULT="$(docker ps)"

  if [[ $(echo $DOCKER_PS_RESULT) =~ "Cannot connect to the Docker daemon" ]]; then
    echo "Error: Docker service isn't running"
    exit 1
  fi

  if [[ ! $(echo $DOCKER_PS_RESULT) =~ "greensense-ui-http" ]]; then
    echo "Error: greensense-ui-http docker container isn't running"
    exit 1
  fi

  cd $DIR
else
  echo "[mock] sh start-linear-mqtt-config-http.sh"
fi

echo "Finished exposing Linear MQTT Dashboard config file via HTTP."
