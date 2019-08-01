echo "Upgrading system..."

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

HOST=$(cat /etc/hostname)

INSTALLED_VERSION="$(cat version.txt)-$(cat buildnumber.txt)"

LATEST_BUILD_NUMBER=$(curl -s -H 'Cache-Control: no-cache' "https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/buildnumber.txt")
LATEST_VERSION_NUMBER=$(curl -s -H 'Cache-Control: no-cache' "https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/version.txt")

LATEST_FULL_VERSION="$LATEST_VERSION_NUMBER-$LATEST_BUILD_NUMBER"

echo "  Branch: $BRANCH"
echo "  Installed version: $INSTALLED_VERSION"
echo "  Latest version: $LATEST_FULL_VERSION"

if [ "$LATEST_FULL_VERSION" != "" ] & [ "$INSTALLED_VERSION" != "$LATEST_FULL_VERSION" ]; then
  echo "  New GreenSense system version available. Upgrading."
  
  SUDO=""
  if [ ! "$(id -u)" -eq 0 ]; then
      SUDO='sudo'
  fi
    
  echo "  Publishing status to MQTT..."
  bash mqtt-publish.sh "/garden/StatusMessage" "Upgrading"

# Disabled because it can potentially break the system by causing conflicts with docker containers 
#  $SUDO apt-get update && $SUDO apt-get -y upgrade
  
  $SUDO pio upgrade
  
  bash clean-all.sh

  bash update-all.sh

  bash init-runtime.sh
  
  bash upgrade-mqtt-service.sh
  
  $SUDO sh install-apps.sh
  
  echo "  Publishing status to MQTT..."
  bash mqtt-publish.sh "/garden/StatusMessage" "Upgraded"
  
  echo "  Sending email report..."
  bash send-email.sh "GreenSense system upgraded on $HOST" "The GreenSense system was upgraded on $HOST...\n\nPrevious version: $INSTALLED_VERSION\nNew version: $LATEST_FULL_VERSION"
  
  echo "Finished upgrading system"
else
  echo "  GreenSense system is up to date. Skipping upgrade."
fi
