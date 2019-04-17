echo "Installing UI controller"

INSTALL_DIR="/usr/local/BridgeArduinoSerialToMqttSplitCsv"

echo "Install dir:"
echo "  $INSTALL_DIR"

mkdir -p $INSTALL_DIR

cp -v -r BridgeArduinoSerialToMqttSplitCsv/ $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv
cp -v BridgeArduinoSerialToMqttSplitCsv*.nupkg $INSTALL_DIR/
cp -v init.sh $INSTALL_DIR/
cp -v install-package.sh $INSTALL_DIR/
cp -v start-mqtt-bridge-from-github.sh $INSTALL_DIR/

