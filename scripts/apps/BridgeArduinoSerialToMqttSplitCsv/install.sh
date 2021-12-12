echo "[MqttBridge - install.sh] Installing MQTT bridge"


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


echo "[MqttBridge - install.sh]   Branch: $BRANCH"
echo "[MqttBridge - install.sh]   Install dir:"
echo "[MqttBridge - install.sh]     $INSTALL_DIR"

if [ -d "$INSTALL_DIR" ]; then
  echo "[MqttBridge - install.sh]   Removing previous MQTT bridge..."
  rm $INSTALL_DIR -R
fi

echo "[MqttBridge - install.sh]   Creating new MQTT bridge directory..."
mkdir -p $INSTALL_DIR

cp -r BridgeArduinoSerialToMqttSplitCsv/ $INSTALL_DIR/BridgeArduinoSerialToMqttSplitCsv/ || exit 1
cp BridgeArduinoSerialToMqttSplitCsv*.zip $INSTALL_DIR/ || exit 1
cp init.sh $INSTALL_DIR/ || exit 1
cp install-package-from-github-release.sh $INSTALL_DIR/ || exit 1
cp start-mqtt-bridge.sh $INSTALL_DIR/ || exit 1

echo "[MqttBridge - install.sh] Finished installing MQTT bridge"
