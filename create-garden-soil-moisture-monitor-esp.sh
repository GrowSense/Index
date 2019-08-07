echo ""
echo "Creating garden ESP/WiFi soil moisture monitor configuration"
echo ""

# Example:
# sh create-garden-monitor-esp.sh [Label] [DeviceName] [Port]
# sh create-garden-monitor-esp.sh "WiFiMonitor1" wifiMonitor1 ttyUSB0 

DIR=$PWD

DEVICE_LABEL=$1
DEVICE_NAME=$2
DEVICE_PORT=$3

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="monitorW1"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="monitorW1"
fi

if [ ! $DEVICE_PORT ]; then
  DEVICE_PORT="ttyUSB0"
fi

echo "  Device label: $DEVICE_LABEL"
echo "  Device name: $DEVICE_NAME"
echo "  Device port: $DEVICE_PORT"
echo ""

# Set up mobile UI
#echo "Setting up Linear MQTT Dashboard UI..."
# TODO: Remove if not needed. Supervisor now takes care of creating the Linear MQTT Dashboard UI
#sh create-garden-monitor-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT || exit 1

# Create device info
sh create-device-info.sh esp monitor SoilMoistureSensorCalibratedSerialESP $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT || exit 1

# Set the WiFi and MQTT settings on the device
if [ ! -f "is-mock-hardware.txt" ]; then
  cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP/ && \
  sh pull-security-files.sh && \
  
  # Give the device time to load
  sleep 3
  
  sh send-wifi-mqtt-commands.sh /dev/$DEVICE_PORT || exit 1
  sh send-mqtt-device-name-command.sh $DEVICE_NAME /dev/$DEVICE_PORT || exit 1
  cd $DIR
else
  echo "  [mock] sh sh send-wifi-mqtt-commands.sh /dev/$DEVICE_PORT"
fi

# Skip the MQTT bridge service because it's not needed for the ESP version

# Skip the sketch upload

echo ""
echo "Garden ESP/WiFi soil moisture monitor created with device name '$DEVICE_NAME'"
