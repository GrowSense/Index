echo "Updating GreenSense plug and play..."

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

PNP_INSTALL_DIR="$BASE_DIR/ArduinoPlugAndPlay"


echo "Checking for ArduinoPlugAndPlay install dir..."
if [ ! -d $PNP_INSTALL_DIR ]; then
  echo "ArduinoPlugAndPlay doesn't appear to be installed at:"
  echo "  $PNP_INSTALL_DIR"
  echo "Use the install-plug-and-play-from-web-sh script instead."
  exit 1
fi

INDEX_DIR=$INSTALL_DIR

echo "Checking for GreenSense index dir..."
if [ ! -d $INDEX_DIR ]; then
  echo "GreenSense Index doesn't appear to be installed at:"
  echo "  $INDEX_DIR"
  echo "Use the install-plug-and-play-from-web-sh script instead."
  exit 1
fi

echo "Moving to GreenSense index dir..."
cd $INDEX_DIR

echo "Publishing status to MQTT..."
sh mqtt-publish.sh "/garden/StatusMessage" "Updating" || echo "MQTT publish failed."

echo "Stopping garden..."
sh stop-garden.sh || exit 1

echo "Updating index..."
sh update-all.sh || exit 1

echo "Upgrading..."
sh upgrade.sh || exit 1

echo "Reinitializing index..."
sh init-runtime.sh || exit 1

echo "Recreating UI..."
sh recreate-garden-ui.sh || exit 1

echo "Recreating garden services..."
sh recreate-garden-services.sh || exit 1

echo "Reloading systemctl..."
if [ ! -f "is-mock-systemctl.txt" ]; then
  systemctl daemon-reload  || exit 1
else
  echo "[mock] systemctl daemon-reload"
fi

echo "Start garden services..."
sh start-garden.sh || exit 1

echo "Updating ArduinoPlugAndPlay (by downloading update-from-web.sh file)..."
wget -q --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-web/update-from-web.sh | bash -s -- $BRANCH $PNP_INSTALL_DIR || exit 1

echo "Moving to GreenSense index dir..."
cd $INDEX_DIR

echo "Giving services time to start..."
sleep 10

echo "Publishing status to MQTT..."
sh mqtt-publish.sh "/garden/StatusMessage" "Update Complete" || echo "MQTT publish failed."


echo "Finished reinstalling GreenSense plug and play!"
