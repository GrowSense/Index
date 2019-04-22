echo "Retrieving required libraries..."

echo "Installing libraries..."

CONFIG_FILE="BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe.config";
CONFIG_FILE_TMP="BridgeArduinoSerialToMqttSplitCsv.exe.config";

if [ -f $CONFIG_FILE ]; then
  echo "Config file found. Preserving."

  if [ ! -f $CONFIG_FILE_TMP ]; then
    cp $CONFIG_FILE $CONFIG_FILE_TMP || exit 1
  fi
fi

# TODO: Clean up. This check is disabled to allow the install package script to be overwritten
if [ ! -f "install-package.sh" ]; then
  INSTALL_SCRIPT_FILE_URL="https://raw.githubusercontent.com/GreenSense/Index/master/scripts/apps/BridgeArduinoSerialToMqttSplitCsv/install-package.sh"
  wget --no-cache -O install-package.sh $INSTALL_SCRIPT_FILE_URL
fi

sh install-package.sh BridgeArduinoSerialToMqttSplitCsv 1.0.1.31 || exit 1

echo "Installation complete."

if [ -f $CONFIG_FILE_TMP ]; then
  echo "Preserved config file found. Restoring."

  echo "Backing up empty config file"
  cp $CONFIG_FILE $CONFIG_FILE.bak

  echo "Restoring existing config file"
  cp $CONFIG_FILE_TMP $CONFIG_FILE || exit 1
fi

