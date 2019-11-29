echo ""
echo "Creating ESP device"
echo ""

# Example:
EXAMPLE="Syntax:\n  sh create-esp-device.sh [Board] [Group] [Project] [Label] [DeviceName]  [Port]"

DIR=$PWD

DEVICE_BOARD=$1
DEVICE_GROUP=$2
DEVICE_PROJECT=$3
DEVICE_LABEL=$4
DEVICE_NAME=$5
DEVICE_PORT=$6

if [ ! $DEVICE_LABEL ]; then
  echo "  Error: Please provide a device label as an argument."
  echo "${EXAMPLE}"
  exit 1
fi

if [ ! $DEVICE_NAME ]; then
  echo "  Error: Please provide a device name as an argument."
  echo "${EXAMPLE}"
  exit 1
fi

if [ ! $DEVICE_GROUP ]; then
  echo "  Error: Please provide a device group as an argument."
  echo "${EXAMPLE}"
  exit 1
fi

if [ ! $DEVICE_PROJECT ]; then
  echo "  Error: Please provide a device project as an argument."
  echo "${EXAMPLE}"
  exit 1
fi

if [ ! $DEVICE_BOARD ]; then
  echo "  Error: Please provide a device board as an argument."
  echo "${EXAMPLE}"
  exit 1
fi

if [ ! $DEVICE_PORT ]; then
  echo "  Error: Please provide a device port as an argument."
  echo "${EXAMPLE}"
  exit 1
fi

echo "  Device label: $DEVICE_LABEL"
echo "  Device name: $DEVICE_NAME"
echo "  Device group: $DEVICE_GROUP"
echo "  Device project: $DEVICE_PROJECT"
echo "  Device board: $DEVICE_BOARD"
echo "  Device port: $DEVICE_PORT"

echo ""
echo "  Setting device name, WiFi and MQTT settings on devices..."
if [ ! -f "is-mock-hardware.txt" ]; then
  echo "  Sending device name command..."
  sh send-device-name-command.sh $DEVICE_NAME /dev/$DEVICE_PORT || exit 1

  cd sketches/$DEVICE_GROUP/$DEVICE_PROJECT/ && \
  sh pull-security-files.sh && \
  
  # Give the device time to load
  sleep 5
  
  sh send-wifi-mqtt-commands.sh /dev/$DEVICE_PORT || exit 1
  cd $DIR
else
  echo "  [mock] sh send-device-name-command.sh $DEVICE_NAME /dev/$DEVICE_PORT"
  echo "  [mock] sh send-wifi-mqtt-commands.sh /dev/$DEVICE_PORT"
fi

echo ""
echo "  Creating device info..."
sh create-device-info.sh esp $DEVICE_GROUP $DEVICE_PROJECT $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT || exit 1

echo "ESP/WiFi device created with name '$DEVICE_NAME'"
