# NOTE: Run this script with sudo

DIR=$PWD

sudo apt-get update && sudo apt-get -y install wget git zip unzip curl add-apt-repository apt-transport-https && \

cd scripts/install/ && \

sh install-platformio.sh && \
sudo sh install-jq.sh && \
sudo sh install-systemd.sh && \
sudo sh install-docker.sh && \
sudo sh install-mono.sh && \

cd $DIR
