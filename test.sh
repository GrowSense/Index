echo "----------" && \
echo "Testing the GreenSense index" && \
echo "----------" && \

NEW_SETTINGS_FILE="mobile/linearmqtt/newsettings.json"

MQTT_HOST="localhost"
MQTT_USERNAME="myusername"
MQTT_PASSWORD="mypassword"

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


sh set-mqtt-credentials.sh $MQTT_HOST $MQTT_USERNAME $MQTT_PASSWORD && \

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

. ./check-ci-skip.sh

if [ $SKIP_CI = 1 ]; then
  echo "Skipping test"
  exit 1
else
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
  
  sh test-monitor-esp.sh && \
  
  sh test-irrigator.sh && \
  
  sh test-irrigator-esp.sh && \
  
  #sh remove-garden-device.sh $IRRIGATOR_DEVICE_NAME && \
  
  #sh create-garden-monitor.sh $MONITOR_LABEL $MONITOR_DEVICE_NAME $MONITOR_PORT && \
  #sh create-garden-irrigator.sh $IRRIGATOR_LABEL $IRRIGATOR_DEVICE_NAME $IRRIGATOR_PORT && \
  
  #sh remove-garden-devices.sh || (echo "Failed to remove devices" && exit 1)
  
  # Disabled
  #sh disable-garden.sh
  
  echo "" && \
  echo "Testing complete"
fi