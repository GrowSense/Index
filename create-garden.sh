echo ""
echo "Creating GreenSense garden..."
echo ""

# Only create the MQTT broker service if the MQTT host is localhost
MQTT_HOST=$(cat mqtt-host.security)
if [ "$MQTT_HOST" = "localhost" ] || [ "$MQTT_HOST" = "127.0.0.1" ]; then
  echo "MQTT broker is local host"
  bash create-mqtt-service.sh
else
  echo "MQTT broker is on another host"
fi

sh expose-ui-config-via-http.sh

echo ""
echo "Setup complete"
echo ""
