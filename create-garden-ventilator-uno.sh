echo ""
echo "Creating garden ventilator configuration"
echo ""

# Example:
# sh create-garden-ventilator.sh [Label] [DeviceName] [Port]
# sh create-garden-ventilator.sh "Ventilator1" ventilator1 ttyUSB0 

DIR=$PWD

DEVICE_LABEL=$1
DEVICE_NAME=$2
DEVICE_PORT=$3

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Ventilator1"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="ventilator1"
fi

if [ ! $DEVICE_PORT ]; then
  DEVICE_PORT="ttyUSB0"
fi

echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"

# Set up mobile UI
sh create-garden-ventilator-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Create device info
sh create-device-info.sh uno ventilator TemperatureHumidityDHTSensorFan $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Set up MQTT bridge service
sh create-mqtt-bridge-service.sh ventilator $DEVICE_NAME $DEVICE_PORT && \

# Set up update service
sh create-updater-service.sh ventilator uno $DEVICE_NAME $DEVICE_PORT && \

# Uploading sketch
sh upload-ventilator-uno-sketch.sh $DEVICE_PORT && \

# Display the device details
#echo "Device info:"
#sh view-garden-device.sh $DEVICE_NAME && \

echo "Garden ventilator created with device name '$DEVICE_NAME'"
