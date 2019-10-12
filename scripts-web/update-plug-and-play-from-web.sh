echo "Updating GrowSense plug and play..."

BRANCH=$1
INSTALL_DIR=$2

EXAMPLE_COMMAND="Example:\n..sh [Branch] [InstallDir]"

if [ ! $BRANCH ]; then
  BRANCH="master"
fi

if [ "$INSTALL_DIR" = "?" ]; then
    INSTALL_DIR="/usr/local/GrowSense/Index"
fi
if [ ! "$INSTALL_DIR" ]; then
    INSTALL_DIR="/usr/local/GrowSense/Index"
fi

echo "Branch: $BRANCH"
echo "Install dir: $INSTALL_DIR"


INDEX_DIR="$INSTALL_DIR"
GREENSENSE_DIR="$(dirname $INSTALL_DIR)"
BASE_DIR="$(dirname $GREENSENSE_DIR)"

PNP_INSTALL_DIR="$BASE_DIR/ArduinoPlugAndPlay"


echo "Checking for ArduinoPlugAndPlay install dir..."
if [ ! -d $PNP_INSTALL_DIR ]; then
  echo "ArduinoPlugAndPlay doesn't appear to be installed at:"
  echo "  $PNP_INSTALL_DIR"
  echo "Use the install-plug-and-play-from-web-sh script instead."
  exit 1
fi

INDEX_DIR=$INSTALL_DIR

echo "Checking for GrowSense index dir..."
if [ ! -d $INDEX_DIR ]; then
  echo "GrowSense Index doesn't appear to be installed at:"
  echo "  $INDEX_DIR"
  echo "Use the install-plug-and-play-from-web-sh script instead."
  exit 1
fi

echo "Moving to GrowSense index dir..."
cd $INDEX_DIR

WIFI_NAME=$(cat wifi-name.security)
WIFI_PASSWORD=$(cat wifi-password.security)

echo "WiFi Name: $WIFI_NAME"
echo "WiFi Password: [hidden]"

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

echo "MQTT Host: $MQTT_HOST"
echo "MQTT Username: $MQTT_USERNAME"
echo "MQTT Password: [hidden]"
echo "MQTT PORT: $MQTT_PORT"

echo "Waiting for the installation to unlock..."
bash "wait-for-unlock.sh" # In quotes to avoid color coding issue in editor

echo "Publishing status to MQTT..."
sh mqtt-publish.sh "/garden/StatusMessage" "Upgrading" &

echo "Giving the UI time to receive the status update..."
sleep 5

#echo "Stopping arduino plug and play..."
#sh systemctl.sh stop arduino-plug-and-play.service # TODO: Remove if not needed. Causing problems because if ArduinoPlugAndPlay is already up to date the service doesn't restart

echo "Stopping garden..."
sh stop-garden.sh || exit 1

echo "Updating index..."
sh update-all.sh || exit 1

echo "Upgrading system..."
sh upgrade-system.sh || exit 1

echo "Reinitializing index..."
sh init-runtime.sh || exit 1

echo "Upgrading ArduinoPlugAndPlay (by downloading upgrade.sh script)..."
curl -s -L -H 'Cache-Control: no-cache' -f https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-ols/upgrade.sh | bash -s -- "$BRANCH" "$PNP_INSTALL_DIR" || exit 1

echo "Waiting for the plug and play system to load."
bash "wait-for-plug-and-play.sh" # In quotes to avoid color coding issue in editor

echo "Recreating UI..."
sh recreate-garden-ui.sh || exit 1

echo "Recreating garden services..."
sh recreate-garden-services.sh || exit 1

# TODO: Remove if not needed. Likely causing problems with plug and play starting after garden services have started
#echo "Reloading systemctl..."
#if [ ! -f "is-mock-systemctl.txt" ]; then
#  systemctl daemon-reload  || exit 1
#else
#  echo "[mock] systemctl daemon-reload"
#fi

echo "Moving to GrowSense index dir..."
cd $INDEX_DIR

echo "Start garden services..."
sh start-garden.sh || exit 1

echo "Waiting for plug and play..."
bash "wait-for-plug-and-play.sh"

#echo "Giving services time to start..."
#sleep 10

echo "Publishing status to MQTT..."
sh mqtt-publish.sh "/garden/StatusMessage" "Upgrade Complete" || echo "MQTT publish failed."


echo "Finished reinstalling GrowSense plug and play!"
