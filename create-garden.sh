echo ""
echo "Creating GrowSense garden..."
echo ""

echo ""
echo "  Creating mesh manager service..."
bash create-mesh-manager-service.sh || exit 1

echo "  Creating WWW service..."
bash create-www-service.sh || exit 1

echo "  Creating WWW upgrading service..."
bash create-www-upgrading-service.sh || exit 1

echo "  Creating network setup service..."
bash create-network-setup-service.sh || exit 1

# Only create the MQTT broker service if the MQTT host is localhost
# Note: The localhost check has been disabled so the MQTT broker will be installed anyway
#MQTT_HOST=$(cat mqtt-host.security)
#if [ "$MQTT_HOST" = "localhost" ] || [ "$MQTT_HOST" = "127.0.0.1" ]; then
#  echo "MQTT broker is local host"
  echo "  Creating MQTT service..."
  bash create-mqtt-service.sh || exit 1
#else
#  echo "MQTT broker is on another host"
#fi

echo ""
echo "Creating upgrade service..."
bash create-upgrade-service.sh || exit 1

echo ""
echo "Creating system supervisor service..."
bash create-supervisor-service.sh || exit 1

echo ""
echo "  Reloading systemctl daemon..."
bash systemctl.sh daemon-reload

echo ""
echo "Setup complete"
echo ""
