echo "Retrieving required libraries..."

echo "Installing libraries..."

CONFIG_FILE="ArduinoPlugAndPlay/lib/net40/ArduinoPlugAndPlay.exe.config";
CONFIG_FILE_TMP="ArduinoPlugAndPlay.exe.config";

if [ -f $CONFIG_FILE ]; then
  echo "Config file found. Preserving."

  if [ ! -f $CONFIG_FILE_TMP ]; then
    cp $CONFIG_FILE $CONFIG_FILE_TMP || exit 1
  fi
fi

sh install-package.sh ArduinoPlugAndPlay 1.0.2.54 || exit 1

echo "Installation complete."

if [ -f $CONFIG_FILE_TMP ]; then
  echo "Preserved config file found. Restoring."

  echo "Backing up empty config file"
  cp $CONFIG_FILE $CONFIG_FILE.bak

  echo "Restoring existing config file"
  cp $CONFIG_FILE_TMP $CONFIG_FILE || exit 1

fi

