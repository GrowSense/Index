DOCKER_PS_RESULT="$(docker ps)"

HOST=$(cat /etc/hostname)

if [[ $(echo $DOCKER_PS_RESULT) =~ "Cannot connect to the Docker daemon" ]]; then
  echo "Docker service isn't running"
  bash send-email.sh "Docker isn't runnning on $HOST" "The docker service isn't running on $HOST\n\nResult from 'docker ps' command: $DOCKER_PS_RESULT"

  bash create-alert-file.sh "Docker isn't runnning on $HOST"
fi

if [[ ! $(echo $DOCKER_PS_RESULT) =~ "mosquitto" ]]; then
  echo "mosquitto docker container isn't running"
  bash send-email.sh "mosquitto docker container isn't running on $HOST" "The mosquitto MQTT broker docker container isn't running on $HOST\n\nResult from 'docker ps' command: $DOCKER_PS_RESULT"

  bash create-alert-file.sh "mosquitto docker container isn't running on $HOST"
fi

# TODO: Remove if not needed. Should be obsolete as Linear MQTT Dashboard is being phased out.
#if [[ ! $(echo $DOCKER_PS_RESULT) =~ "growsense-ui-http" ]]; then
# echo "GrowSense UI HTTP access docker container isn't running"
#  bash send-email.sh "GrowSense UI HTTP access docker container isn't running on $HOST" "The nginx docker container which exposes the Linear MQTT Dashboard config file via HTTP isn't running on $HOST\n\nResult from 'docker ps' command: $DOCKER_PS_RESULT"

#  bash create-alert-file.sh "GrowSense UI HTTP access docker container isn't running on $HOST"
#fi
