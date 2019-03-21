DIR=$PWD

# Only launch it if docker is enabled
if [ ! -f "is-mock-docker.txt" ]; then

  cd scripts/docker/nginx

  sh start-linear-mqtt-config-http.sh

  cd $DIR
else
  echo "[mock] sh start-linear-mqtt-config-http.sh"
fi
