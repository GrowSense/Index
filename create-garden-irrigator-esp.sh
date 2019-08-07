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
echo ""

# Set up mobile UI
echo "Setting up Linear MQTT Dashboard UI..."
# TODO: Remove if not needed. Supervisor now takes care of creating the Linear MQTT Dashboard UI
#sh create-garden-irrigator-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Create device info
sh create-device-info.sh esp irrigator SoilMoistureSensorCalibratedPumpESP $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \

# Set the WiFi and MQTT settings on the device
if [ ! -f "is-mock-hardware.txt" ]; then
  cd sketches/irrigator/SoilMoistureSensorCalibratedPumpESP/ && \
  sh pull-security-files.sh && \
  
  # Give the device time to load
  sleep 3
  
  sh send-wifi-mqtt-commands.sh /dev/$DEVICE_PORT || exit 1
  sh send-mqtt-device-name-command.sh $DEVICE_NAME /dev/$DEVICE_PORT || exit 1
  cd $DIR
else
  echo "  [mock] sh sh send-wifi-mqtt-commands.sh /dev/$DEVICE_PORT"
fi

# Skip the MQTT bridge service because it's not needed for the ESP version and the updater service because it won't work when not plugged in via USB

# Skip the sketch upload

echo "Garden ESP/WiFi irrigator created with device name '$DEVICE_NAME'"
