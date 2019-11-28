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

bash create-arduino-device.sh nano irrigator SoilMoistureSensorCalibratedPump $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT || exit 1

echo "Garden irrigator created with device name '$DEVICE_NAME'"
