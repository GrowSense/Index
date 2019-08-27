echo "Installing UI controller"

INSTALL_DIR="/usr/local/BridgeArduinoSerialToMqttSplitCsv"

echo "Install dir:"
echo "  $INSTALL_DIR"

mkdir -p $INSTALL_DIR

cp -v -r BridgeArduinoSerialToMqttSplitCsv/ $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv || exit 1
cp -v BridgeArduinoSerialToMqttSplitCsv*.zip $INSTALL_DIR/ || exit 1
cp -v init.sh $INSTALL_DIR/ || exit 1
cp -v install-package-from-github-release.sh $INSTALL_DIR/ || exit 1
cp -v start-mqtt-bridge.sh $INSTALL_DIR/ || exit 1

