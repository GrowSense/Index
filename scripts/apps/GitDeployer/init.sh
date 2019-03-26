echo "Retrieving required libraries..."

echo "Installing libraries..."

# TODO: Clean up
if [ ! -f "install-package.sh" ]; then
  INSTALL_SCRIPT_FILE_URL="https://raw.githubusercontent.com/GreenSense/Index/master/scripts/apps/BridgeArduinoSerialToMqttSplitCsv/install-package.sh"
  wget -O install-package.sh $INSTALL_SCRIPT_FILE_URL
fi

sh install-package.sh GitDeployer 1.0.0.32 || exit 1

echo "Installation complete"
