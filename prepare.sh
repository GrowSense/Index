# NOTE: Run this script with sudo

DIR=$PWD

apt-get update && apt-get -y install wget git jq zip unzip curl apt-transport-https && \

cd scripts/install/ && \

sh install-systemd.sh && \
sh install-docker.sh && \
sh install-platformio.sh && \
sh install-mono.sh && \

cd $DIR
