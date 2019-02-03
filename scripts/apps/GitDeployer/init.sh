echo "Retrieving required libraries..."

# Nuget is disabled
# sh get-nuget.sh
# sh nuget-update-self.sh

echo "Installing libraries..."

if [ ! -f "install-package.sh" ]; then
  INSTALL_SCRIPT_FILE_URL="https://raw.githubusercontent.com/GreenSense/Index/master/scripts/apps/BridgeArduinoSerialToMqttSplitCsv/install-package.sh"
  wget $INSTALL_SCRIPT_FILE_URL
fi

sh install-package.sh GitDeployer 10.0.0.20 || exit 1

echo "Installation complete"
