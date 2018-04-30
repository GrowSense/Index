# NOTE: Run this script with sudo

DIR=$PWD

apt-get update && apt-get -y install git jq zip unzip curl && \

cd scripts/install/ && \

sh install-systemd.sh && \
sh install-docker.sh && \
sh install-platformio.sh && \
sh install-mono.sh && \

cd $DIR
