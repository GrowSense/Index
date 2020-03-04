echo "Installing MQTT bridge"

INSTALL_DIR=$1

if [ ! $INSTALL_DIR ]; then
  INSTALL_DIR="/usr/local/BridgeArduinoSerialToMqttSplitCsv"
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
cp -v install-package-from-github-release.sh $INSTALL_DIR/ || exit 1
cp -v start-mqtt-bridge.sh $INSTALL_DIR/ || exit 1

echo "Finished installing MQTT bridge"
