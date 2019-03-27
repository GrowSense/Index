# NOTE: Run this script with sudo

DIR=$PWD

apt-get update && apt-get -y install wget git zip unzip curl software-properties-common apt-transport-https mosquitto-clients xmlstarlet && \

cd scripts/install/ && \

sh install-platformio.sh && \
sh install-jq.sh && \
sh install-systemd.sh && \
sh install-docker.sh && \
sh install-mono.sh && \

cd $DIR
