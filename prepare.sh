# NOTE: Run this script with sudo

DIR=$PWD

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

APT_UPDATE_EXECUTED=0

if ! type "wget" > /dev/null; then
   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
   $SUDO apt-get -y -q install wget
fi

if ! type "git" > /dev/null; then
   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
   $SUDO apt-get -y install git
fi

if ! type "zip" > /dev/null; then
   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
   $SUDO apt-get -y -q install zip
fi

if ! type "unzip" > /dev/null; then
   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
   $SUDO apt-get -y -q install unzip
fi

if ! type "curl" > /dev/null; then
   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
   $SUDO apt-get -y -q install curl
fi

if [[ ! $(dpkg -s software-properties-common) ]]; then
   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
   $SUDO apt-get -y -q install software-properties-common
fi

if [[ ! $(dpkg -s ca-certificates) ]]; then
   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
   $SUDO apt-get -y -q install ca-certificates
fi

if [[ ! $(dpkg -s apt-transport-https) ]]; then
   [ ! $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
   $SUDO apt-get -y -q install apt-transport-https
fi

if [[ ! $(dpkg -s mosquitto-clients) ]]; then
   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
   $SUDO apt-get -y -q install mosquitto-clients
fi

if ! type "xmlstarlet" > /dev/null; then
   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
   $SUDO apt-get -y -q install xmlstarlet
fi

if ! type "sshpass" > /dev/null; then
   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
   $SUDO apt-get -y -q install sshpass
fi

if type xhost > /dev/null; then
  if ! type "notify-send" > /dev/null; then
    [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
    $SUDO apt-get -y -q install notify-send || "notify-send install skipped"
  fi
fi

cd scripts/install/ && \

sh install-platformio.sh && \
sh install-jq.sh && \
sh install-systemd.sh && \
sh install-docker.sh && \
sh install-mono.sh && \
#sh install-hub.sh && \

cd $DIR
