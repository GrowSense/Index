echo ""
echo "Creating GrowSense garden..."
echo ""

# Only create the MQTT broker service if the MQTT host is localhost
# Note: The localhost check has been disabled so the MQTT broker will be installed anyway
#MQTT_HOST=$(cat mqtt-host.security)
#if [ "$MQTT_HOST" = "localhost" ] || [ "$MQTT_HOST" = "127.0.0.1" ]; then
#  echo "MQTT broker is local host"
  bash create-mqtt-service.sh || exit 1
#else
#  echo "MQTT broker is on another host"
#fi

bash expose-ui-config-via-http.sh || exit 1

echo ""
echo "Setup complete"
echo ""
