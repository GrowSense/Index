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

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Irrigator1"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="irrigator1"
fi

if [ ! $DEVICE_PORT ]; then
  DEVICE_PORT="ttyUSB0"
fi

echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"

# Remove any existing services
# TODO: Remove if not needed. Should be obsolete
#sh remove-garden-device.sh $DEVICE_NAME && \

# NOTE: Set up the UI before the device info otherwise it will think it already exists and won't add it to the UI

# Set up mobile UI
# TODO: Remove if not needed. Supervisor now takes care of creating the Linear MQTT Dashboard UI
#sh create-garden-irrigator-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Create device info
sh create-device-info.sh nano irrigator SoilMoistureSensorCalibratedPump $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Upload sketch
#sh upload-irrigator-nano-sketch.sh $DEVICE_PORT && \

# Set up MQTT bridge service
sh create-mqtt-bridge-service.sh irrigator $DEVICE_NAME $DEVICE_PORT && \

# Set up update service
#sh create-updater-service.sh irrigator nano $DEVICE_NAME $DEVICE_PORT && \

# Display the device details
#echo "Device info:"
#sh view-garden-device.sh $DEVICE_NAME

echo "Garden irrigator created with device name '$DEVICE_NAME'"
