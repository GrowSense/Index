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
  
  if [ $? == 0 ]; then
    echo ""
    echo "  Cleaning all..."
    bash clean-all.sh
  fi

  if [ $? == 0 ]; then
  echo ""
  echo "  Updating all..."
  bash update-all.sh
  fi

  if [ $? == 0 ]; then
    echo ""
    echo "  Initializing runtime..."
    bash init-runtime.sh
  fi
  
  if [ $? == 0 ]; then
    echo ""
    echo "  Upgrading MQTT service..."
    bash upgrade-mqtt-service.sh
  fi

  if [ $? == 0 ]; then
    echo ""
    echo "  Recreating garden services..."
    sh recreate-garden-services.sh || exit 1
  fi
  
  if [ $? == 0 ]; then
    echo ""
    echo "  Installing apps..."
     $SUDO sh install-apps.sh
  fi
  
  if [ $? == 0 ]; then
    echo ""
    echo "  Recreating garden services..."
    sh recreate-garden-services.sh
  fi

  # TODO: Remove if not needed. Recreating garden services should restart the garden.
  #if [ $? == 0 ]; then
  #  echo ""
  #  echo "  Restarting garden..."
  #  bash restart-garden.sh
  #fi

  if [ $? == 0 ]; then
    echo ""
    echo "  Upgrading ArduinoPlugAndPlay (by downloading upgrade.sh script)..."
    curl -s -L -H 'Cache-Control: no-cache' -f https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-ols/upgrade.sh | bash -s -- "$BRANCH" "$PNP_INSTALL_DIR"
  fi

  if [ $? == 0 ]; then
    echo ""
    echo "  Waiting for the plug and play system to load..."
    bash "wait-for-plug-and-play.sh" # In quotes to avoid color coding issue in editor
  fi
  
  if [ $? == 0 ]; then
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
    echo ""
    echo ""
  else
    echo ""
    echo "Error: GrowSense system upgrade failed."
    echo ""
    echo ""

    exit 1
  fi

else
  echo "  GrowSense system is up to date. Skipping upgrade."
  echo ""
fi
