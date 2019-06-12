echo ""
echo "Creating garden irrigator configuration"
echo ""

# Example:
# sh create-garden-irrigator.sh [Label] [DeviceName] [Port]
# sh create-garden-irrigator.sh "Irrigator1" irrigator1 ttyUSB0 

DIR=$PWD

DEVICE_LABEL=$1
DEVICE_NAME=$2
DEVICE_PORT=$3
FAST=$4

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="IrrigatorW1"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="irrigatorW1"
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
sh create-garden-irrigator-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Create device info
sh create-device-info.sh esp irrigator SoilMoistureSensorCalibratedPumpESP $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Skip the MQTT bridge service because it's not needed for the ESP version and the updater service because it won't work when not plugged in via USB

# Upload sketch
if [ "$FAST" = "fast" ]; then
  echo "Uploading sketch in background..."
  nohup sh upload-irrigator-esp-sketch.sh $DEVICE_NAME $DEVICE_PORT >/dev/null 2>&1 &
else
  echo "Uploading sketch..."
  sh upload-irrigator-esp-sketch.sh $DEVICE_NAME $DEVICE_PORT
fi
sh upload-irrigator-esp-sketch.sh $DEVICE_NAME $DEVICE_PORT && \

echo "Garden ESP/WiFi irrigator created with device name '$DEVICE_NAME'"
