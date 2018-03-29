sudo apt-get update && sudo apt-get -y install systemd jq zip unzip && \

sudo sh scripts/install/install-docker.sh && \
sudo sh scripts/install/install-platformio.sh && \
sudo sh scripts/install/install-mono.sh
