echo "[MqttBridge - init.sh] Retrieving required libraries..."

echo "[MqttBridge - init.sh] Installing libraries..."

BRANCH=$1

CONFIG_FILE="BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config";
CONFIG_FILE_TMP="BridgeArduinoSerialToMqttSplitCsv.exe.config";

if [ -f $CONFIG_FILE ]; then
  echo "[MqttBridge - init.sh] Config file found. Preserving."

  if [ ! -f $CONFIG_FILE_TMP ]; then
    cp $CONFIG_FILE $CONFIG_FILE_TMP || exit 1
  fi
fi

VERSION="$(cat version.txt)"

bash install-package-from-github-release.sh CompulsiveCoder BridgeArduinoSerialToMqttSplitCsv $VERSION $BRANCH || exit 1

echo "[MqttBridge - init.sh] Installation complete."

if [ -f $CONFIG_FILE_TMP ]; then
  echo "[MqttBridge - init.sh] Preserved config file found. Restoring."

  echo "[MqttBridge - init.sh] Backing up empty config file"
  cp $CONFIG_FILE $CONFIG_FILE.bak

  echo "[MqttBridge - init.sh]Restoring existing config file"
  cp $CONFIG_FILE_TMP $CONFIG_FILE || exit 1
fi

