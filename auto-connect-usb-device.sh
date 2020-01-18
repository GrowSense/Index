BOARD_TYPE=$1
FAMILY_NAME=$2
GROUP_NAME=$3
PROJECT_NAME=$4
SCRIPT_CODE=$5
PORT=$6
DEVICE_NAME=$7

EXAMPLE="Example:\n\tauto-connect-usb-device.sh [BoardType] [ProjectFamily] [ProjectGroup] [ProjectName] [ScriptCode] [Port] [DeviceName]"

if [ ! $FAMILY_NAME ]; then
  echo "Provide a family name as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! $GROUP_NAME ]; then
  echo "Provide a group name as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! $PROJECT_NAME ]; then
  echo "Provide a project name as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! $BOARD_TYPE ]; then
  echo "Provide a board type as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! $SCRIPT_CODE ]; then
  echo "Provide a script code as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! $PORT ]; then
  echo "Provide a port as an argument."
  echo $EXAMPLE
  exit 1
fi

echo "Automatically connecting a device..."

echo ""
echo "  Board: $BOARD_TYPE"
echo "  Family: $FAMILY_NAME"
echo "  Group: $GROUP_NAME"
echo "  Project: $PROJECT_NAME"
echo "  Script code: $SCRIPT_CODE"
echo "  Port: $PORT"
echo "  Device name (provided): $DEVICE_NAME"
echo ""

HOST=$(cat /etc/hostname)

DEVICE_NAME_IS_IN_USE=0
if [ "$DEVICE_NAME" != "" ]; then
  if [ -d "devices/$DEVICE_NAME" ]; then
    DEVICE_HOST="$(cat devices/$DEVICE_NAME/host.txt)"
    if [ "$HOST" != "$DEVICE_HOST" ]; then
      echo "  Device name $DEVICE_NAME is already in use on another host."
      DEVICE_NAME_IS_IN_USE=1
    fi
  fi
fi

if [ ! $DEVICE_NAME ] || [[ $DEVICE_NAME = *"New"* ]] || [ $DEVICE_NAME = "{DEVICENAME}" ] || [ "$DEVICE_NAME_IS_IN_USE" = "1" ]; then
  echo "  Generating a new device name."
  . ./generate-device-name.sh $GROUP_NAME $PROJECT_NAME $BOARD_TYPE || exit 1
fi

bash notify-send.sh "Connecting $DEVICE_NAME device"

bash mqtt-publish-device.sh $DEVICE_NAME StatusMessage Connecting -r

echo "Device name: $DEVICE_NAME"
echo "Device number: $DEVICE_NUMBER"

echo "Device info dir:"
echo "  $DEVICE_INFO_DIR"

DEVICE_LABEL="$(echo $DEVICE_NAME | sed 's/.*/\u&/')" || exit 1

echo ""
echo "  Launching create device script..."
if [ "$BOARD_TYPE" = "esp" ]; then
  bash create-esp-device.sh $BOARD_TYPE $GROUP_NAME $PROJECT_NAME $DEVICE_LABEL $DEVICE_NAME $PORT || exit 1
else
  bash create-arduino-device.sh $BOARD_TYPE $GROUP_NAME $PROJECT_NAME $DEVICE_LABEL $DEVICE_NAME $PORT || exit 1
fi

echo ""
echo "Marking device as connected..."
echo "1" > "devices/$DEVICE_NAME/is-usb-connected.txt"

bash mqtt-publish-device.sh $DEVICE_NAME StatusMessage Connected -r

bash notify-send.sh "Finished connecting $GROUP_NAME device"

bash create-message-file.sh "$DEVICE_LABEL connected"

bash send-email.sh "Device $DEVICE_LABEL connected via USB (on $HOST)." "The $DEVICE_LABEL device was connected via USB on host $HOST."

echo ""
echo "Finished connecting device: $DEVICE_NAME."