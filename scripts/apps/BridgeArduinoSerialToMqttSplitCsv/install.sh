echo "Installing MQTT bridge"


BRANCH=$1
INSTALL_DIR=$2

if [ ! $INSTALL_DIR ]; then
  INSTALL_DIR="/usr/local/BridgeArduinoSerialToMqttSplitCsv"
fi


if [ ! "$BRANCH" ]; then
  BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
fi
if [ ! $BRANCH ]; then
  BRANCH="lts"
fi


echo "  Install dir:"
echo "    $INSTALL_DIR"

if [ -d "$INSTALL_DIR" ]; then
  echo "  Removing previous MQTT bridge..."
  rm $INSTALL_DIR -R
fi

echo "  Creating new MQTT bridge directory..."
mkdir -p $INSTALL_DIR

cp -v -r BridgeArduinoSerialToMqttSplitCsv/ $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv/ || exit 1
cp -v BridgeArduinoSerialToMqttSplitCsv*.zip $INSTALL_DIR/ || exit 1
cp -v init.sh $INSTALL_DIR/ || exit 1
cp -v install-package-from-github-release.sh $BRANCH $INSTALL_DIR/ || exit 1
cp -v start-mqtt-bridge.sh $INSTALL_DIR/ || exit 1

echo "Finished installing MQTT bridge"
