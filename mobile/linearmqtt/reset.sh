echo "Resetting Linear MQTT configuration..."

echo ""
echo "Resetting device count..."
sh reset-device-count.sh || exit 1

echo ""
echo "Copying template.json file to newsettings.json file..."
cp template.json newsettings.json -r

# TODO: Remove if not needed
# Disabled because it's unnecessary and takes time
#echo ""
#echo "Initializing settings..."
sh init-settings.sh || exit 1

# TODO: Remove if not needed
# Disabled because it's unnecessary and takes time
#echo ""
#echo "Extracting parts from template..."
sh extract-parts.sh || exit 1

echo ""
echo "Finished resetting linear MQTT configuration"
