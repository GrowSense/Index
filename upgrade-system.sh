echo "Upgrading system..."

FORCE_UPGRADE=$1

if [ ! "$FORCE_UPGRADE" ]; then
  FORCE_UPGRADE=0
fi

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

HOST=$(cat /etc/hostname)

INSTALLED_VERSION="$(cat version.txt)-$(cat buildnumber.txt)"

LATEST_BUILD_NUMBER=$(curl -s -H 'Cache-Control: no-cache' "https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/buildnumber.txt")
LATEST_VERSION_NUMBER=$(curl -s -H 'Cache-Control: no-cache' "https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/version.txt")

LATEST_FULL_VERSION="$LATEST_VERSION_NUMBER-$LATEST_BUILD_NUMBER"

echo "  Branch: $BRANCH"
echo "  Installed version: $INSTALLED_VERSION"
echo "  Latest version: $LATEST_FULL_VERSION"
echo "  Force upgrade: $FORCE_UPGRADE"

if [ ! "$LATEST_BUILD_NUMBER" ] && [[ "$FORCE_UPGRADE" -eq "0" ]]; then
  echo "  Error: Failed to get the latest build number. Skipping upgrade."
  exit 1
elif [ ! "$LATEST_VERSION_NUMBER" ] && [[ "$FORCE_UPGRADE" -eq "0" ]]; then
  echo "  Error: Failed to get the latest version number. Skipping upgrade."
  exit 1
elif [[ "$FORCE_UPGRADE" -eq "1" ]] || [ "$INSTALLED_VERSION" != "$LATEST_FULL_VERSION" ]; then
  if [ "$INSTALLED_VERSION" != "$LATEST_FULL_VERSION" ]; then
    echo "  New GrowSense system version available."
  elif [[ "$FORCE_UPGRADE" -eq "1" ]]; then
    echo "  Forcing upgrade."
  fi

  echo "  Upgrading..."

  echo ""
  echo "  Waiting for the installation to unlock..."
  bash "wait-for-unlock.sh" # In quotes to avoid color coding issue in editor

  echo "  Setting 'is-upgrading.txt' flag..."
  echo "1" > "is-upgrading.txt"

  SUDO=""
  if [ ! "$(id -u)" -eq 0 ]; then
      SUDO='sudo'
  fi

  echo "  Publishing status to MQTT..."
  bash mqtt-publish.sh "garden/StatusMessage" "Upgrading"

  echo "  Sending email report..."
  bash send-email.sh "GrowSense system upgrading to v$LATEST_FULL_VERSION (on $HOST)" "The GrowSense system is upgrading on $HOST...\n\nPrevious version: $INSTALLED_VERSION\nNew version: $LATEST_FULL_VERSION"

  echo ""
  echo "Creating status message file..."
  bash create-message-file.sh "GrowSense system upgrading"

  echo ""
  echo "  Giving the UI time to receive the status update..."
  sleep 5

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Stopping supervisor to prevent unnecessary errors..."
    bash stop-supervisor.sh
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Stopping WW service..."
    bash stop-www-service.sh
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Starting WWW upgrading service..."
    bash create-www-upgrading-service.sh
    bash start-www-upgrading-service.sh
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Cleaning all..."
    bash clean-all.sh
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Upgrading platform.io..."
    pio upgrade
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Updating all..."
    bash update-all.sh
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Initializing runtime..."
    bash init-runtime.sh
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Upgrading MQTT service..."
    bash upgrade-mqtt-service.sh
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Installing apps..."
    $SUDO sh install-apps.sh
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "Setting WiFi credentials..."

    WIFI_NAME=$(cat wifi-name.security)
    WIFI_PASSWORD=$(cat wifi-password.security)

    echo ""
    echo "    WiFi Name: $WIFI_NAME"
    echo "    WiFi Password: [hidden]"

    bash set-wifi-credentials.sh $WIFI_NAME $WIFI_PASSWORD
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Setting MQTT details..."

    MQTT_HOST=$(cat mqtt-host.security)
    MQTT_USERNAME=$(cat mqtt-username.security)
    MQTT_PASSWORD=$(cat mqtt-password.security)
    MQTT_PORT=$(cat mqtt-port.security)

    echo ""
    echo "    MQTT Host: $MQTT_HOST"
    echo "    MQTT Username: $MQTT_USERNAME"
    echo "    MQTT Password: [hidden]"
    echo "    MQTT PORT: $MQTT_PORT"

    bash set-mqtt-credentials.sh $MQTT_HOST $MQTT_USERNAME $MQTT_PASSWORD $MQTT_PORT
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Setting email details..."

    SMTP_SERVER=$(cat smtp-server.security)
    ADMIN_EMAIL=$(cat admin-email.security)
    SMTP_USERNAME=$(cat smtp-username.security)
    SMTP_PASSWORD=$(cat smtp-password.security)
    SMTP_PORT=$(cat smtp-port.security)

    echo ""
    echo "    SMTP Server: $SMTP_SERVER"
    echo "    Adming Email: $ADMIN_EMAIL"
    echo "    SMTP Server: $SMTP_USERNAME"
    echo "    SMTP Username: [hidden]"
    echo "    SMTP Password: $SMTP_PORT"

    bash set-email-details.sh $SMTP_SERVER $ADMIN_EMAIL $SMTP_USERNAME $SMTP_PASSWORD $SMTP_PORT
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Stopping WWW upgrading service..."
    bash stop-www-upgrading-service.sh
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Recreating garden services..."
    bash recreate-garden-services.sh
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Starting garden..."
    bash start-garden.sh
  fi

  if [ "$?" -eq "0" ]; then
    BASE_DIR="$(dirname $(dirname $PWD))"
    PNP_INSTALL_DIR="$BASE_DIR/ArduinoPlugAndPlay"

    echo "  Checking for ArduinoPlugAndPlay install dir..."
    if [ ! -d $PNP_INSTALL_DIR ]; then
      echo "    ArduinoPlugAndPlay doesn't appear to be installed at:"
      echo "      $PNP_INSTALL_DIR"
      echo "    Use the install-plug-and-play-from-web-sh script instead."

      echo ""
      echo "  Removing 'is-upgrading.txt' flag..."
      rm is-upgrading.txt || echo "  Failed to remove is-upgrading.txt flag. It must has been removed manually."

      exit 1
    fi

    echo ""
    echo "  Upgrading ArduinoPlugAndPlay (by downloading upgrade.sh script)..."
    curl -s -L -H 'Cache-Control: no-cache' -f https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-ols/upgrade.sh | bash -s -- "$BRANCH" "$PNP_INSTALL_DIR"
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Waiting for the plug and play system to load..."
    bash "wait-for-plug-and-play.sh" # In quotes to avoid color coding issue in editor
  fi

  if [ "$?" -eq "0" ]; then
    echo ""
    echo "  Publishing status to MQTT..."
    bash mqtt-publish.sh "garden/StatusMessage" "Upgraded"

    echo ""
    echo "  Sending email report..."
    UPGRADE_SERVICE_LOG=$(bash view-upgrade-service-log.sh)
    bash send-email.sh "GrowSense system upgraded to v$LATEST_FULL_VERSION (on $HOST)" "The GrowSense system was upgraded on $HOST...\n\nPrevious version: $INSTALLED_VERSION\nNew version: $LATEST_FULL_VERSION\n\nLog output..\n\n$UPGRADE_SERVICE_LOG"

    echo ""
    echo "  Creating message file..."
    bash create-message-file.sh "GrowSense upgraded to v$LATEST_FULL_VERSION"

    echo ""
    echo "Finished upgrading system"
    echo ""
    echo ""

    echo ""
    echo "  Removing 'is-upgrading.txt' flag..."
    rm is-upgrading.txt || echo "  Failed to remove is-upgrading.txt flag. It must has been removed manually."
  else
    echo ""
    echo "Error: GrowSense system upgrade failed."
    echo ""
    echo ""

    echo ""
    echo "  Removing 'is-upgrading.txt' flag..."
    rm is-upgrading.txt || echo "  Failed to remove is-upgrading.txt flag. It must has been removed manually."

    exit 1
  fi

else
  echo "  GrowSense system is up to date. Skipping upgrade."
  echo ""
fi
