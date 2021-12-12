echo "[install-apps.sh] Installing required apps..."

BRANCH=$1

if [ ! "$BRANCH" ]; then
  BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
fi
if [ ! "$BRANCH" ]; then
  BRANCH=lts
fi

DIR=$PWD

echo "[install-apps.sh] Installing system UI controller..."

UI_CONTROLLER_INSTALL_DIR=""
if [ -f "is-mock-system.txt" ]; then
  UI_CONTROLLER_INSTALL_DIR="../../../../Serial1602ShieldSystemUIController"
fi

cd scripts/apps/Serial1602ShieldSystemUIController
bash install.sh $UI_CONTROLLER_INSTALL_DIR || exit 1
cd $DIR

echo "[install-apps.sh] Installing MQTT bridge..."

MQTT_BRIDGE_INSTALL_DIR=""
if [ -f "is-mock-system.txt" ]; then
  MQTT_BRIDGE_INSTALL_DIR="../../../../../BridgeArduinoSerialToMqttSplitCsv"
fi

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv
bash install.sh $BRANCH $MQTT_BRIDGE_INSTALL_DIR || exit 1
cd $DIR

echo "[install-apps.sh] Finished installing required apps."


