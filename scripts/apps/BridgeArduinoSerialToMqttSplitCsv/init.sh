echo "Retrieving required libraries..."

# Nuget is disabled
# sh get-nuget.sh
# sh nuget-update-self.sh

echo "Installing libraries..."

CONFIG_FILE="BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config";
CONFIG_FILE_TMP="BridgeArduinoSerialToMqttSplitCsv.exe.config";


if [ -f $CONFIG_FILE ]; then
  echo "Config file found. Preserving."

  cp $CONFIG_FILE $CONFIG_FILE_TMP || exit 1
fi

sh nuget-install.sh BridgeArduinoSerialToMqttSplitCsv 1.0.0.38 || exit 1

echo "Installation complete. Launching deployer."

if [ -f $CONFIG_FILE_TMP ]; then
  echo "Preserved config file found. Restoring."

  echo "Backing up empty config file"
  cp $CONFIG_FILE $CONFIG_FILE.bak

  echo "Restoring existing config file"
  cp $CONFIG_FILE_TMP $CONFIG_FILE || exit 1
fi

