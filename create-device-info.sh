
DEVICE_BOARD=$1
DEVICE_GROUP=$2
DEVICE_PROJECT=$3
DEVICE_LABEL=$4
DEVICE_NAME=$5
DEVICE_PORT=$6
DEVICE_HOST=$7


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

echo "Device board: $DEVICE_BOARD"
echo "Device group: $DEVICE_GROUP"
echo "Device type: $DEVICE_PROJECT"
echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"
echo "Device host: $DEVICE_HOST"

DEVICE_FAMILY="GreenSense"

DEVICES_DIR=$PWD/devices

mkdir -p  $DEVICES_DIR

DEVICE_DIR=$DEVICES_DIR/$DEVICE_NAME

mkdir -p $DEVICE_DIR

echo $DEVICE_BOARD > $DEVICE_DIR/board.txt
echo $DEVICE_PROJECT > $DEVICE_DIR/project.txt
echo $DEVICE_LABEL > $DEVICE_DIR/label.txt
echo $DEVICE_NAME > $DEVICE_DIR/name.txt
echo $DEVICE_PORT > $DEVICE_DIR/port.txt
echo $DEVICE_GROUP > $DEVICE_DIR/group.txt
echo $DEVICE_FAMILY > $DEVICE_DIR/family.txt
echo $DEVICE_HOST > $DEVICE_DIR/host.txt

echo "Device info created"
