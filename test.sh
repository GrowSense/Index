echo "----------" && \
echo "Testing the GreenSense index" && \
echo "----------" && \

NEW_SETTINGS_FILE="mobile/linearmqtt/newsettings.json"

MQTT_USERNAME="myusername"
MQTT_PASSWORD="mypassword"

MONITOR_LABEL="MyMonitor"
MONITOR_DEVICE_NAME="mymonitor"
MONITOR_PORT="ttyUSB0"
MONITOR_CALIBRATED_TOPIC="/$MONITOR_DEVICE_NAME/C"

IRRIGATOR_LABEL="MyIrrigator"
IRRIGATOR_DEVICE_NAME="myirrigator"
IRRIGATOR_PORT="ttyUSB1"
IRRIGATOR_CALIBRATED_TOPIC="/$IRRIGATOR_DEVICE_NAME/C"

echo "----------"
echo "Preparing to test"
echo "----------"

echo ""
echo "Removing garden devices"
echo ""

sh remove-garden-devices.sh && \

echo "----------"
echo "Executing test"
echo "----------"

echo "" && \
echo "Setting MQTT credentials" && \
echo "" && \


sh set-mqtt-credentials.sh $MQTT_USERNAME $MQTT_PASSWORD && \

echo "" && \
echo "Checking mosquitto userfile" && \
echo "" && \

FOUND_CREDENTIALS_STRING=$(cat scripts/docker/mosquitto/data/mosquitto.userfile)
if [ "$FOUND_CREDENTIALS_STRING" = "$MQTT_USERNAME:$MQTT_PASSWORD" ]; then
  echo "  Mosquitto userfile is valid"
else
  echo "  Mosquitto userfile is invalid. Expected '$MQTT_USERNAME:$MQTT_PASSWORD' but was '$FOUND_CREDENTIALS_STRING'"
  exit 1
fi

echo "" && \
echo "Removing existing docker services" && \
echo "" && \

# Mosquitto test isn't working in travis CI so its disabled
#sudo systemctl is-active --quiet service \
#  && sudo systemctl stop greensense-mosquitto-docker.service \
#  && sudo systemctl disable greensense-mosquitto-docker.service \

#docker stop mosquitto || echo "No mosquitto container running. Skipped."
#docker rm mosquitto || echo "No mosquitto container found. Skipped."

echo "" && \
echo "Creating garden services" && \
echo "" && \

sh test-garden.sh && \

sh test-monitor.sh && \

#sh test-monitor-esp.sh && \

sh test-irrigator.sh && \

#sh remove-garden-device.sh $IRRIGATOR_DEVICE_NAME && \

#sh create-garden-monitor.sh $MONITOR_LABEL $MONITOR_DEVICE_NAME $MONITOR_PORT && \
#sh create-garden-irrigator.sh $IRRIGATOR_LABEL $IRRIGATOR_DEVICE_NAME $IRRIGATOR_PORT && \

#sh remove-garden-devices.sh || (echo "Failed to remove devices" && exit 1)

# Disabled
#sh disable-garden.sh

echo "" && \
echo "Testing complete"

