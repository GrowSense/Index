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

echo "Checking for ArduinoPlugAndPlay install dir..."
if [ -d $PNP_INSTALL_DIR ]; then
  cd $PNP_INSTALL_DIR

  echo "Uninstalling the plug and play application (by downloading uninstall-from-web.sh file)..."
  wget -q --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-web/uninstall-from-web.sh | bash -s $BRANCH $PNP_INSTALL_DIR
else
  echo "ArduinoPlugAndPlay doesn't seem to be installed. Skipping."
  echo "  $PNP_INSTALL_DIR"
fi

INDEX_DIR="$INSTALL_DIR"

echo "Checking for GreenSense index dir..."
if [ ! -d $INDEX_DIR ]; then
  echo "GreenSense Index doesn't appear to be installed at:"
  echo "  $INDEX_DIR"
  echo "Aborting uninstall."
else
  echo "Moving to GreenSense index dir..."
  cd $INDEX_DIR
  
  echo "Publishing status to MQTT..."
  sh mqtt-publish.sh "/garden/StatusMessage" "Uninstalling" || echo "MQTT publish failed."

  echo "Giving the UI time to display the message..."
  sleep 3

  echo "Stopping garden..."
  sh stop-garden.sh || echo "Failed to stop garden"

  echo "Removing all devices and services..."
  sh remove-garden-devices.sh || exit 1

  echo "Removing GreenSense directory..."
  rm $INSTALL_DIR -R || exit 1
fi

if [ -d "$BASE_DIR/mqtt-bridge" ]; then
  echo "Removing MQTT bridge install directory..."
  rm "$BASE_DIR/mqtt-bridge" -R
fi

if [ -d "$BASE_DIR/git-deployer" ]; then
  echo "Removing updater (git deployer) install directory..."
  rm "$BASE_DIR/git-deployer" -R
fi

if [ -d "$BASE_DIR/Serial1602ShieldSystemUIController" ]; then
  echo "Removing UI controller install directory..."
  rm "$BASE_DIR/Serial1602ShieldSystemUIController" -R
fi

if [ -d "$BASE_DIR/mosquitto" ]; then
  echo "Removing mosquitto install directory..."
  rm "$BASE_DIR/mosquitto" -R
  docker stop mosquitto || echo "Skipping stop mosquitto"
  docker rm mosquitto || echo "Skipping remove mosquitto"
fi


echo "Finished uninstalling GreenSense plug and play!"
  

