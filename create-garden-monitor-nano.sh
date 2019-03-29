echo ""
echo "Creating garden monitor ESP8266 configuration"
echo ""

# Example:
# sh create-garden-monitor-esp.sh [Label] [DeviceName] [Port]
# sh create-garden-monitor-esp.sh "Monitor1" monitor1 ttyUSB0 

DIR=$PWD

DEVICE_LABEL=$1
DEVICE_NAME=$2
DEVICE_PORT=$3

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Monitor1"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="monitor1"
fi

if [ ! $DEVICE_PORT ]; then
  DEVICE_PORT="ttyUSB0"
fi

echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"

# Set up mobile UI
echo "Setting up Linear MQTT Dashboard UI..." && \
sh create-garden-monitor-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Create device info
sh create-device-info.sh nano monitor SoilMoistureSensorCalibratedSerial $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Set up MQTT bridge service
sh create-mqtt-bridge-service.sh monitor $DEVICE_NAME $DEVICE_PORT && \

# Set up update service
#sh create-updater-service.sh monitor nano $DEVICE_NAME $DEVICE_PORT && \

# Uploading sketch
#sh upload-monitor-nano-sketch.sh $DEVICE_PORT && \

# Display the device details
#echo "Device info:"
#sh view-garden-device.sh $DEVICE_NAME && \

echo "Garden monitor created with device name '$DEVICE_NAME'"
