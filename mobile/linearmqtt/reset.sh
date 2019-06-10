echo "Resetting Linear MQTT configuration..."

echo ""
echo "  Resetting device count..."
sh reset-device-count.sh || exit 1

echo ""
echo "  Initializing settings..."
sh init-settings.sh || exit 1

echo ""
echo "  Extracting parts from template..."
sh extract-parts.sh || exit 1

echo ""
echo "Finished resetting linear MQTT configuration"
