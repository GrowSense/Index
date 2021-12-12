MAX_LOOPS=50

if [ ! "$LOOP_NUMBER" ]; then
  LOOP_NUMBER=1
fi

MOSQUITTO_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MOSQUITTO_INSTALL_DIR="/usr/local/mosquitto"

#docker pull compulsivecoder/mosquitto-arm

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  SUDO='sudo'
fi

didSucceed=0;
loopNumber=1

while [ "$didSucceed" -eq "0" ] && [ "$loopNumber" -lt "$MAX_LOOPS" ]; do
  echo "Running mosquitto docker container..."
  echo "  Loop number $loopNumber"

  docker pull eclipse-mosquitto && didSucceed=1 || didSucceed=0

  docker rm -f mosquitto

  echo "Mosquitto data dir: $MOSQUITTO_DIR/data"

  $SUDO cp -v $MOSQUITTO_DIR/data $MOSQUITTO_INSTALL_DIR -r

  # If statement commented out so if docker pull fails it will attempt to start the container anyway using an existing image
  #if [ "$didSucceed" == "1" ]; then
    docker run -d \
      --restart=always \
      --name=mosquitto \
      --volume $MOSQUITTO_INSTALL_DIR/data:/mosquitto/config \
      --network="host" \
      -p 127.0.0.1:1883:1883/tcp \
	  eclipse-mosquitto && didSucceed=1 || didSucceed=0
  #fi

  if [ "$didSucceed" == "0" ]; then
    echo "Error: Failed to start mosquitto docker container"
    if [[ "$LOOP_NUMBER" -lt "$MAX_LOOPS" ]]; then
      echo "  Restarting docker service..."
      $SUDO service docker restart
      loopNumber=$(($loopNumber+1))
      docker stop mosquitto
      docker rm mosquitto
    fi
  fi
done
