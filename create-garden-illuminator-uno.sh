echo ""
echo "Creating garden illuminator configuration"
echo ""

# Example:
# sh create-garden-illuminator.sh [Label] [DeviceName] [Port]
# sh create-garden-illuminator.sh "Illuminator1" illuminator1 ttyUSB0 

DIR=$PWD

DEVICE_LABEL=$1
DEVICE_NAME=$2
DEVICE_PORT=$3

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Illuminator1"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="illuminator1"
fi

if [ ! $DEVICE_PORT ]; then
  DEVICE_PORT="ttyUSB0"
fi

echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"

# Set up mobile UI
sh create-garden-illuminator-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Create device info
sh create-device-info.sh uno illuminator LightPRSensorCalibratedLight $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Set up MQTT bridge service
sh create-mqtt-bridge-service.sh illuminator $DEVICE_NAME $DEVICE_PORT && \

# Set up update service
sh create-updater-service.sh illuminator uno $DEVICE_NAME $DEVICE_PORT && \

# Uploading sketch
sh upload-illuminator-uno-sketch.sh $DEVICE_PORT && \

echo "Garden illuminator created with device name '$DEVICE_NAME'"
