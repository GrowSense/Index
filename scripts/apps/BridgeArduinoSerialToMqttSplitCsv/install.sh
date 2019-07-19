echo "Installing UI controller"

INSTALL_DIR="/usr/local/BridgeArduinoSerialToMqttSplitCsv"

echo "Install dir:"
echo "  $INSTALL_DIR"

mkdir -p $INSTALL_DIR

cp -v -r BridgeArduinoSerialToMqttSplitCsv/ $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv
cp -v BridgeArduinoSerialToMqttSplitCsv*.nupkg $INSTALL_DIR/
cp -v init.sh $INSTALL_DIR/
cp -v install-package-from-github-release.sh $INSTALL_DIR/
cp -v start-mqtt-bridge.sh $INSTALL_DIR/

