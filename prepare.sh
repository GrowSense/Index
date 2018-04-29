DIR=$PWD

sudo apt-get update && sudo apt-get -y install git jq zip unzip && \

cd scripts/install/ && \

sudo sh install-systemd.sh && \
sudo sh install-docker.sh && \
sudo sh install-platformio.sh && \
sudo sh install-mono.sh && \

cd $DIR
