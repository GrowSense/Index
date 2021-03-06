
DEVICE_BOARD=$1
DEVICE_GROUP=$2
DEVICE_PROJECT=$3
DEVICE_LABEL=$4
DEVICE_NAME=$5
DEVICE_PORT=$6
DEVICE_HOST=$7

echo ""
echo "Creating device info..."

EXAMPLE_TEXT="Example: sh create-device-info.sh uno monitor SoilMoistureSensorCalibratedSerial Monitor1 monitor1 ttyUSB0"

if [ ! $DEVICE_BOARD ]; then
  echo "Device board must be specified as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $DEVICE_GROUP ]; then
  echo "Device project group must be specified as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $DEVICE_PROJECT ]; then
  echo "Device project must be specified as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $DEVICE_LABEL ]; then
  echo "Device label must be specified as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $DEVICE_NAME ]; then
  echo "Device name must be specified as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $DEVICE_PORT ]; then
  echo "Device port must be specified as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $DEVICE_HOST ]; then
  DEVICE_HOST=$(cat /etc/hostname)
fi

echo "  Board: $DEVICE_BOARD"
echo "  Group: $DEVICE_GROUP"
echo "  Type: $DEVICE_PROJECT"
echo "  Label: $DEVICE_LABEL"
echo "  Device name: $DEVICE_NAME"
echo "  Port: $DEVICE_PORT"
echo "  Host: $DEVICE_HOST"

DEVICE_FAMILY="GrowSense"

DEVICES_DIR=$PWD/devices

mkdir -p  $DEVICES_DIR

DEVICE_DIR=$DEVICES_DIR/$DEVICE_NAME

mkdir -p $DEVICE_DIR || exit 1

echo $DEVICE_BOARD > $DEVICE_DIR/board.txt || exit 1
echo $DEVICE_PROJECT > $DEVICE_DIR/project.txt || exit 1
echo $DEVICE_LABEL > $DEVICE_DIR/label.txt || exit 1
echo $DEVICE_NAME > $DEVICE_DIR/name.txt || exit 1
echo $DEVICE_PORT > $DEVICE_DIR/port.txt || exit 1
echo $DEVICE_GROUP > $DEVICE_DIR/group.txt || exit 1
echo $DEVICE_FAMILY > $DEVICE_DIR/family.txt || exit 1
echo $DEVICE_HOST > $DEVICE_DIR/host.txt || exit 1
echo "1" > $DEVICE_DIR/is-usb-connected.txt || exit 1

PNP_DEVICES_DIR="/usr/local/ArduinoPlugAndPlay/devices"

if [ -f "is-mock-system.txt" ]; then
  PNP_DEVICES_DIR="mock/ArduinoPlugAndPlay/devices"
fi

mkdir -p "$PNP_DEVICES_DIR/$DEVICE_PORT" || exit 1

echo "$DEVICE_NAME" > "$PNP_DEVICES_DIR/$DEVICE_PORT/device-name.txt" || exit 1

echo "Finished creating device info"
echo ""
