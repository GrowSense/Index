echo "Uninstalling GrowSense plug and play..."

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

echo "Base dir: $BASE_DIR"

PNP_INSTALL_DIR="$BASE_DIR/ArduinoPlugAndPlay"

echo ""
echo "Checking for ArduinoPlugAndPlay install dir..."
if [ -d $PNP_INSTALL_DIR ]; then
  cd $PNP_INSTALL_DIR

  echo ""
  echo "Uninstalling the plug and play application (by downloading uninstall-from-web.sh file)..."
  wget -nv --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-ols/uninstall.sh | bash -s $BRANCH $PNP_INSTALL_DIR
else
  echo ""
  echo "ArduinoPlugAndPlay doesn't seem to be installed. Skipping."
  echo "  $PNP_INSTALL_DIR"
fi

INDEX_DIR="$INSTALL_DIR"

echo ""
echo "Checking for GrowSense index dir..."
if [ ! -d $INDEX_DIR ]; then
  echo "GrowSense Index doesn't appear to be installed at:"
  echo "  $INDEX_DIR"
  echo "Aborting uninstall."
else
  echo "Moving to GrowSense index dir..."
  cd $INDEX_DIR
  
  echo "Waiting for the installation to unlock..."
  bash "wait-for-unlock.sh" # In quotes to avoid color coding issue in editor

  echo ""
  echo "Publishing status to MQTT..."
  sh mqtt-publish.sh "/garden/StatusMessage" "Uninstalling" &

  echo ""
  echo "Giving the UI time (3 seconds) to display the message..."
  sleep 3

  echo ""
  echo "Stopping garden..."
  sh stop-garden.sh || echo "Failed to stop garden"

  echo ""
  echo "Removing all devices and services..."
  sh remove-garden-devices.sh || echo "Failed to remove garden devices"

  echo ""
  echo "Removing GrowSense directory..."
  echo "  $INSTALL_DIR"
  rm $INSTALL_DIR -R || exit 1
  echo ""
fi

echo ""
echo "Removing MQTT bridge install directory..."
MQTT_BRIDGE_INSTALL_DIR="$BASE_DIR/BridgeArduinoSerialToMqttSplitCsv"
echo "  $MQTT_BRIDGE_INSTALL_DIR"
if [ -d "$MQTT_BRIDGE_INSTALL_DIR" ]; then
  rm "$MQTT_BRIDGE_INSTALL_DIR" -R || exit 1
  echo "  Removal complete."
else
  echo "  Not found. Skipping removal."
fi

echo ""
echo "Removing UI controller install directory..."
UI_CONTROLLER_INSTALL_DIR="$BASE_DIR/Serial1602ShieldSystemUIController"
echo "  $UI_CONTROLLER_INSTALL_DIR"
if [ -d "$UI_CONTROLLER_INSTALL_DIR" ]; then
  rm "$UI_CONTROLLER_INSTALL_DIR" -R || exit 1
  echo "  Removal complete."
else
  echo "  Not found. Skipping removal."
fi

echo ""
echo "Removing mosquitto install directory..."
MOSQUITTO_INSTALL_DIR="$BASE_DIR/mosquitto"
echo "  $MOSQUITTO_INSTALL_DIR"
if [ -d "$MOSQUITTO_INSTALL_DIR" ]; then
  rm "$MOSQUITTO_INSTALL_DIR" -R || exit 1
  echo "  Removal complete."
else
  echo "  Not found. Skipping removal."
fi

echo ""
echo "Removing mosquitto docker container..."
docker stop mosquitto || echo "Mosquitto docker container not found. Skipping stop."
docker rm mosquitto || echo "Mosquitto docker container not found. Skipping remove."

echo ""
echo "Removing nginx linear MQTT config HTTP docker container..."
docker stop greensense-ui-http || echo "GrowSense nginx linear MQTT config HTTP docker container not found. Skipping stop."
docker rm greensense-ui-http || echo "GrowSense nginx linear MQTT config HTTP docker container not found. Skipping remove."

echo ""
echo "Finished uninstalling GrowSense plug and play!"
  

