# NOTE: Run this script with sudo

DIR=$PWD

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

$SUDO apt-get update && $SUDO apt-get -y install wget git zip unzip curl software-properties-common apt-transport-https mosquitto-clients xmlstarlet && \



cd scripts/install/ && \

sh install-platformio.sh && \
sh install-jq.sh && \
sh install-systemd.sh && \
sh install-docker.sh && \
sh install-mono.sh && \
#sh install-hub.sh && \

cd $DIR
