echo ""
echo "Creating arduino device configuration"
echo ""

# Example:
EXAMPLE="Syntax:\n  sh create-arduino-device.sh [Board] [Group] [Project] [Label] [DeviceName]  [Port]"

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
echo "  Creating device info..."
sh create-device-info.sh $DEVICE_BOARD $DEVICE_GROUP $DEVICE_PROJECT $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT || exit 1

echo ""
echo "  Stopping device services in case any are running..."
bash stop-garden-device.sh $DEVICE_NAME

echo ""
echo "Sending device name command..."
bash send-device-name-command.sh $DEVICE_NAME "/dev/$DEVICE_PORT"

# Set up service
echo ""
echo "  Creating device service..."
if [ "$DEVICE_GROUP" == "ui" ]; then
  bash create-ui-controller-1602-service.sh $DEVICE_NAME $DEVICE_PORT || exit 1
else
  bash create-mqtt-bridge-service.sh $DEVICE_GROUP $DEVICE_NAME $DEVICE_PORT || exit 1
fi

echo "Arduino device created with name '$DEVICE_NAME'"
