#!/bin/sh

echo "Preparing system for GrowSense installation..."

DIR=$PWD

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

if [ -z "$(find /var/cache/apt/pkgcache.bin -mmin -10080)" ]; then
  $SUDO apt-get update
fi

$SUDO apt-get install -y build-essential wget git zip unzip curl software-properties-common ca-certificates apt-transport-https xmlstarlet sshpass mosquitto-clients

#APT_UPDATE_EXECUTED=0

#if ! type "gcc" &>/dev/null; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install build-essential
#fi

#if ! type "wget" &>/dev/null; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install wget
#fi

#if ! type "git" &>/dev/null; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y install git
#fi

#if ! type "zip" &>/dev/null; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install zip
#fi

#if ! type "unzip" &>/dev/null; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install unzip
#fi

#if ! type "curl" &>/dev/null; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install curl
#fi

#if ! type "sendemail" &>/dev/null; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install sendemail
#fi

#if [[ ! $(dpkg -s software-properties-common) ]]; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install software-properties-common
#fi

#if [[ ! $(dpkg -s ca-certificates) ]]; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install ca-certificates
#fi

#if [[ ! $(dpkg -s apt-transport-https) ]]; then
#   [ ! $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install apt-transport-https
#fi

#if [[ ! $(dpkg -s mosquitto-clients) ]]; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install mosquitto-clients
#fi

#if ! type "xmlstarlet" &>/dev/null; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install xmlstarlet
#fi

#if ! type "sshpass" &>/dev/null; then
#   [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
#   $SUDO apt-get -y -q install sshpass
#fi

if type xhost &>/dev/null; then
  if [[ ! $(dpkg -s notify-send) ]]; then
#    [ $APT_UPDATE_EXECUTED = 0 ] && $SUDO apt-get update && APT_UPDATE_EXECUTED=1
    $SUDO apt-get -y -q install notify-send || "notify-send install skipped"
  fi
fi

cd scripts/install/ && \

echo ""
echo "Installing python..."
bash install-python.sh || exit 1

echo ""
echo "Installing platform.io..."
bash install-platformio.sh || exit 1

echo ""
echo "Installing udev rules..."
bash install-udev-rules.sh || exit 1

# TODO: Remove if not needed. Should be obsolete.
#echo ""
#echo "Installing jq..."
#bash install-jq.sh || exit 1

echo ""
echo "Installing systemd..."
bash install-systemd.sh || exit 1

echo ""
echo "Installing docker..."
bash install-docker.sh || exit 1

echo ""
echo "Installing mono..."
bash install-mono.sh || exit 1

echo ""
echo "Installing email..."
bash install-email.sh || exit 1

#echo ""
#echo "Installing hotspot..."
#bash install-hotspot.sh || exit 1

cd $DIR

echo "Finished preparing system for GrowSense installation."
