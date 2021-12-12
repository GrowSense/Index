echo "Installing required apps..."

BRANCH=$1

if [ ! "$BRANCH" ]; then
  BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
fi
if [ ! "$BRANCH" ]; then
  BRANCH=lts
fi

DIR=$PWD

echo "Installing system UI controller..."

UI_CONTROLLER_INSTALL_DIR=""
if [ -f "is-mock-system.txt" ]; then
  UI_CONTROLLER_INSTALL_DIR="../../../../Serial1602ShieldSystemUIController"
fi

cd scripts/apps/Serial1602ShieldSystemUIController
sh install.sh $UI_CONTROLLER_INSTALL_DIR || exit 1
cd $DIR

echo "Installing MQTT bridge..."

MQTT_BRIDGE_INSTALL_DIR=""
if [ -f "is-mock-system.txt" ]; then
  MQTT_BRIDGE_INSTALL_DIR="../../../../../BridgeArduinoSerialToMqttSplitCsv"
fi

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv
sh install.sh $BRANCH $MQTT_BRIDGE_INSTALL_DIR || exit 1
cd $DIR

echo "Finished installing required apps."


