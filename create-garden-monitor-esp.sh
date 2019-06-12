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
FAST=$4

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
echo "  Fast: $FAST"
echo ""

# Set up mobile UI
echo "Setting up Linear MQTT Dashboard UI..."
sh create-garden-monitor-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT || exit 1

# Create device info
sh create-device-info.sh esp monitor SoilMoistureSensorCalibratedSerialESP $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT || exit 1

# Skip the MQTT bridge service because it's not needed for the ESP version

# Upload sketch
if [ "$FAST" = "fast" ]; then
  echo "Uploading sketch in background..."
  nohup sh upload-monitor-esp-sketch.sh $DEVICE_NAME $DEVICE_PORT >/dev/null 2>&1 &
else
  echo "Uploading sketch..."
  sh upload-monitor-esp-sketch.sh $DEVICE_NAME $DEVICE_PORT
fi

echo ""
echo "Garden ESP/WiFi soil moisture monitor created with device name '$DEVICE_NAME'"
