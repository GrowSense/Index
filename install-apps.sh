echo "Installing required apps..."

DIR=$PWD

echo "Installing system UI controller..."

UI_CONTROLLER_INSTALL_DIR=""
if [ -f "is-mock-system.txt" ]; then
  UI_CONTROLLER_INSTALL_DIR="../../../../../Serial1602ShieldSystemUIController"
fi
cd scripts/apps/Serial1602ShieldSystemUIController
sh install.sh $UI_CONTROLLER_INSTALL_DIR || exit 1
cd $DIR

echo "Installing MQTT bridge..."

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv
sh install.sh || exit 1
cd $DIR

echo "Finished installing required apps."


