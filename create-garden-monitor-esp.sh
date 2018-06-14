echo ""
echo "Creating garden monitor configuration"
echo ""

# Example:
# sh create-garden-monitor-esp.sh [Label] [DeviceName] [Port]
# sh create-garden-monitor-esp.sh "WiFiMonitor1" wifiMonitor1 ttyUSB0 

DIR=$PWD

DEVICE_LABEL=$1
DEVICE_NAME=$2
DEVICE_PORT=$3

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="WiFiMonitor1"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="wifiMonitor1"
fi

if [ ! $DEVICE_PORT ]; then
  DEVICE_PORT="ttyUSB0"
fi

echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"

# Skip the MQTT bridge service because it's not needed for the ESP version and the updater service because it won't work when not plugged in via USB

# Set up mobile UI
echo "Setting up Linear MQTT Dashboard UI..."

cd mobile/linearmqtt/ && \
sh create-garden-monitor-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \
cd $DIR && \

# Uploading sketch
sh upload-monitor-esp-sketch.sh $DEVICE_NAME $DEVICE_PORT && \

echo "Garden ESP8266 monitor created with device name '$DEVICE_NAME'"
