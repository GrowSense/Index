echo "Uninstalling GreenSense plug and play..."

EXAMPLE_COMMAND="Example:\n..sh"

PNP_INSTALL_DIR="/usr/local/ArduinoPlugAndPlay"

echo "Checking for ArduinoPlugAndPlay install dir..."
if [ -d $PNP_INSTALL_DIR ]; then
  cd $PNP_INSTALL_DIR

  echo "Uninstalling the plug and play application (by downloading uninstall-from-web.sh file)..."
  wget -v --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/master/scripts-web/uninstall-from-web.sh | bash -s - $BRANCH || (echo "Failed to uninstall ArduinoPlugAndPlay. Script: uninstall-from-web.sh" && exit 1)
else
  echo "ArduinoPlugAndPlay doesn't seem to be installed. Skipping."
  echo "  $PNP_INSTALL_DIR"
fi

INDEX_DIR="/usr/local/GreenSense/Index"

echo "Checking for GreenSense index dir..."
if [ ! -d $INDEX_DIR ]; then
  echo "GreenSense Index doesn't appear to be installed at:"
  echo "  $INDEX_DIR"
  echo "Aborting uninstall."
  exit 1
else
  echo "Moving to GreenSense index dir..."
  cd $INDEX_DIR

  echo "Removing all devices and services..."
  sh remove-garden-devices.sh || (echo "Failed to remove garden devices." && exit 1)

  echo "Removing all devices and services..."
  sh remove-garden-devices.sh || (echo "Failed to remove garden devices." && exit 1)

  cd "/usr/local/"

  echo "Removing MQTT bridge install directory..."
  rm mqtt-bridge -R || (echo "Failed to remove MQTT bridge install directory." && exit 1)

  echo "Removing updater (git deployer) install directory..."
  rm git-deployer -R || (echo "Failed to remove updater (git deployer) install directory." && exit 1)

  rm "/usr/local/GreenSense"  -R || (echo "Failed to remove GreenSense index directory." && exit 1)
  
  echo "Finished uninstalling GreenSense plug and play!"
fi

