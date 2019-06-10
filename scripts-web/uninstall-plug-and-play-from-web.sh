echo "Uninstalling GreenSense plug and play..."

BRANCH=$1
INSTALL_DIR=$2

EXAMPLE_COMMAND="Example:\n..sh [Branch] [InstallDir]"

if [ ! $BRANCH ]; then
  BRANCH="master"
fi

if [ "$INSTALL_DIR" = "?" ]; then
    INSTALL_DIR="/usr/local/GreenSense/Index"
fi
if [ ! "$INSTALL_DIR" ]; then
    INSTALL_DIR="/usr/local/GreenSense/Index"
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
  wget -q --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-web/uninstall-from-web.sh | bash -s $BRANCH $PNP_INSTALL_DIR
else
  echo ""
  echo "ArduinoPlugAndPlay doesn't seem to be installed. Skipping."
  echo "  $PNP_INSTALL_DIR"
fi

INDEX_DIR="$INSTALL_DIR"

echo ""
echo "Checking for GreenSense index dir..."
if [ ! -d $INDEX_DIR ]; then
  echo "GreenSense Index doesn't appear to be installed at:"
  echo "  $INDEX_DIR"
  echo "Aborting uninstall."
else
  echo "Moving to GreenSense index dir..."
  cd $INDEX_DIR

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
  sh remove-garden-devices.sh || exit 1

  echo ""
  echo "Removing GreenSense directory..."
  echo "  $INSTALL_DIR"
  rm $INSTALL_DIR -R || exit 1
fi

echo ""
echo "Removing MQTT bridge install directory..."
echo "  $BASE_DIR/BridgeArduinoSerialToMqttSplitCsv"
if [ -d "$BASE_DIR/BridgeArduinoSerialToMqttSplitCsv" ]; then
  rm "$BASE_DIR/BridgeArduinoSerialToMqttCsv" -R
  echo "  Removal complete."
else
  echo "  Not found. Skipping removal."
fi

echo ""
echo "Removing UI controller install directory..."
echo "  $BASE_DIR/Serial1602ShieldSystemUIController"
if [ -d "$BASE_DIR/Serial1602ShieldSystemUIController" ]; then
  rm "$BASE_DIR/Serial1602ShieldSystemUIController" -R
  echo "  Removal complete."
else
  echo "  Not found. Skipping removal."
fi

echo ""
echo "Removing mosquitto install directory..."
echo "  "$BASE_DIR/mosquitto""
if [ -d "$BASE_DIR/mosquitto" ]; then
  rm "$BASE_DIR/mosquitto" -R
  echo "  Removal complete."
else
  echo "  Not found. Skipping removal."
fi

echo ""
echo "Removing mosquitto docker container..."
docker stop mosquitto || echo "Skipping stop mosquitto"
docker rm mosquitto || echo "Skipping remove mosquitto"

echo "Finished uninstalling GreenSense plug and play!"
  

