echo "Restarting MQTT docker container..."

echo ""
echo "  Removing MQTT docker container..."
bash remove-mqtt-service.sh || exit 1

echo ""
echo "  Recreating MQTT docker container..."
bash create-mqtt-service.sh || exit 1

echo ""
echo "Finished restarting MQTT docker container."
