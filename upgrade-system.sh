echo "Upgrading system..."

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

HOST=$(cat /etc/hostname)

INSTALLED_VERSION="$(cat version.txt)-$(cat buildnumber.txt)"

LATEST_BUILD_NUMBER=$(curl -s -H 'Cache-Control: no-cache' "https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/buildnumber.txt")
LATEST_VERSION_NUMBER=$(curl -s -H 'Cache-Control: no-cache' "https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/version.txt")

LATEST_FULL_VERSION="$LATEST_VERSION_NUMBER-$LATEST_BUILD_NUMBER"

echo "  Branch: $BRANCH"
echo "  Installed version: $INSTALLED_VERSION"
echo "  Latest version: $LATEST_FULL_VERSION"

if [ ! "$LATEST_BUILD_NUMBER" ]; then
  echo "  Error: Failed to get the latest build number. Skipping upgrade."
  exit 1
elif [ ! "$LATEST_VERSION_NUMBER" ]; then
  echo "  Error: Failed to get the latest version number. Skipping upgrade."
  exit 1
elif [ "$INSTALLED_VERSION" != "$LATEST_FULL_VERSION" ]; then
  echo "  New GrowSense system version available. Upgrading..."
  
  SUDO=""
  if [ ! "$(id -u)" -eq 0 ]; then
      SUDO='sudo'
  fi
    
  echo "  Publishing status to MQTT..."
  bash mqtt-publish.sh "garden/StatusMessage" "Upgrading"

  echo "  Sending email report..."
  bash send-email.sh "GrowSense system upgrading to v$LATEST_FULL_VERSION (on $HOST)" "The GrowSense system was upgraded on $HOST...\n\nPrevious version: $INSTALLED_VERSION\nNew version: $LATEST_FULL_VERSION"
  
# Disabled because it can potentially break the system by causing conflicts with docker containers 
#  $SUDO apt-get update && $SUDO apt-get -y upgrade
  
# Disabled because it shouldn't be needed
  #bash stop-garden-devices.sh
  
  #$SUDO pio upgrade
  
  echo ""
  echo "  Cleaning all..."
  bash clean-all.sh || exit 1

  echo ""
  echo "  Updating all..."
  bash update-all.sh || exit 1

  echo ""
  echo "  Initializing runtime..."
  bash init-runtime.sh || exit 1
  
  echo ""
  echo "  Upgrading MQTT service..."
  bash upgrade-mqtt-service.sh || exit 1
  
  echo ""
  echo "  Installing apps..."
  $SUDO sh install-apps.sh || exit 1
  
  echo ""
  echo "  Restarting garden..."
  bash restart-garden.sh || exit 1
  
  echo ""
  echo "  Publishing status to MQTT..."
  bash mqtt-publish.sh "garden/StatusMessage" "Upgraded"
  
  echo ""
  echo "  Sending email report..."
  bash send-email.sh "GrowSense system upgraded to v$LATEST_FULL_VERSION (on $HOST)" "The GrowSense system was upgraded on $HOST...\n\nPrevious version: $INSTALLED_VERSION\nNew version: $LATEST_FULL_VERSION"
  
  echo ""
  echo "  Creating message file..."
  bash create-message-file.sh "GrowSense upgraded to v$LATEST_FULL_VERSION"

  echo ""
  echo "Finished upgrading system"
else
  echo "  GrowSense system is up to date. Skipping upgrade."
fi
