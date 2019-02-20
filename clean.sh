DIR=$PWD

echo ""
echo "Cleaning project"
echo ""


# Clean linear MQTT dashboard settings
cd mobile/linearmqtt/
sh reset.sh
cd $DIR

# Clean mock directory
MOCK_DIR="mock";
echo "Mock dir: $MOCK_DIR"
if [ -d "$MOCK_DIR" ]; then
  rm "$MOCK_DIR/" -r
fi

# Clean test .tmp directory
TMP_DIR="$PWD.tmp";
echo "Temp dir: $TMP_DIR"
if [ -d "$TMP_DIR" ]; then
  rm "$TMP_DIR/" -r
fi

# Remove all garden devices and services
sh remove-garden-devices.sh

echo "Finished cleaning project"
