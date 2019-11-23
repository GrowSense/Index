echo ""
echo "Restarting all garden services"
echo ""

DIR=$PWD

bash restart-supervisor.sh || exit 1

bash restart-www-service.sh || exit 1

# Only restart the MQTT service if the MQTT host is localhost, otherwise it's not installed/running
MQTT_HOST=$(cat mqtt-host.security)
if [ "$MQTT_HOST" = "localhost" ] || [ "$MQTT_HOST" = "127.0.0.1" ]; then
  bash restart-mqtt.sh || exit 1
fi

bash restart-garden-devices.sh || exit 1