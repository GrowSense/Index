echo ""
echo "Creating garden UI configuration"
echo ""

DIR=$PWD

DEVICE_LABEL=$1
DEVICE_NAME=$2
DEVICE_PORT=$3

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Interface1"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="interface1"
fi

if [ ! $DEVICE_PORT ]; then
  DEVICE_PORT="ttyUSB0"
fi

echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"

# Set up mobile UI
echo "Setting up Linear MQTT Dashboard UI..." && \
#sh create-garden-monitor-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Create device info
sh create-device-info.sh uno ui Serial1602ShieldSystemUI $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Set up MQTT bridge service
sh create-ui-controller-1602-service.sh $DEVICE_NAME $DEVICE_PORT && \

# Set up update service
#sh create-updater-service.sh monitor uno $DEVICE_NAME $DEVICE_PORT && \

# Uploading sketch
#sh upload-monitor-uno-sketch.sh $DEVICE_PORT && \

# Display the device details
#echo "Device info:"
#sh view-garden-device.sh $DEVICE_NAME && \

echo "Garden UI created with device name '$DEVICE_NAME'"
