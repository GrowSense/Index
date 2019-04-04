DIR=$PWD

echo ""
echo "Cleaning project"
echo ""


# Clean linear MQTT dashboard settings
echo "Cleaning UI configuration..."
cd mobile/linearmqtt/
sh reset.sh
cd $DIR

# Clean mock directory
echo "Cleaning mock directory..."
MOCK_DIR="mock";
#echo "Mock dir: $MOCK_DIR"
if [ -d "$MOCK_DIR" ]; then
  rm "$MOCK_DIR/" -r
fi

if [ -d "_tmp" ]; then
  rm "_tmp" -r
fi

# Note: This is commented out because it messes with CI
# Disable mocking
#echo "Disabling mocking..."
#sh disable-mocking.sh

# Remove all garden devices and services
echo "Removing all garden devices..."
sh remove-garden-devices.sh || (echo "Failed to removed garden devices." && exit 1)

# Reset the MQTT details
echo "Resettings MQTT credeitnals..."
sh set-mqtt-credentials.sh 127.0.0.1 user pass123 1883 || (echo "Failed to reset MQTT credentials." && exit 1)

echo "Finished cleaning project"
