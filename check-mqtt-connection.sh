DEVICE_NAME="ConnectionTest"

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

echo "Checking MQTT connection"
echo "  Host: $MQTT_HOST"
echo "  Username: $MQTT_USERNAME"
echo "  Password: [hidden]"
echo "  Port: $MQTT_PORT"

VALUE=$(timeout 10 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "#" -C 1)

if [ ! $VALUE ]; then
  echo "  No data detected"  
else
  echo "  Broker online (data detected)"
fi
