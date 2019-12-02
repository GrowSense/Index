BOARD_TYPE=$1
FAMILY_NAME=$2
GROUP_NAME=$3
PROJECT_NAME=$4
SCRIPT_CODE=$5
PORT=$6
DEVICE_NAME=$7

EXAMPLE="Example:\n\tauto-connect-device.sh [BoardType] [ProjectFamily] [ProjectGroup] [ProjectName] [ScriptCode] [Port] [DeviceName]"

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

if [ ! $DEVICE_NAME ] || [[ $DEVICE_NAME == *"New"* ]] || [[ $DEVICE_NAME == "{DEVICENAME}" ]]; then
  . ./generate-device-name.sh $GROUP_NAME $PROJECT_NAME $BOARD_TYPE || exit 1
fi

bash notify-send.sh "Connecting $DEVICE_NAME device"

bash run-background.sh bash mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Connecting"

echo "Device name: $DEVICE_NAME"
echo "Device number: $DEVICE_NUMBER"

echo "Device info dir:"
echo "  $DEVICE_INFO_DIR"

DEVICE_LABEL="$(echo $DEVICE_NAME | sed 's/.*/\u&/')" || exit 1

# TODO: Remove if not needed. Should be obsolete.
#SCRIPT_NAME="create-garden-$SCRIPT_CODE-$BOARD_TYPE".sh || exit 1
#echo "" && \
#echo "Create device script:" && \
#echo $SCRIPT_NAME "$DEVICE_LABEL" "$DEVICE_NAME" $PORT || exit 1
#echo "" && \
#sh $SCRIPT_NAME "$DEVICE_LABEL" "$DEVICE_NAME" $PORT || exit 1

echo ""
echo "  Launching create device script..."
if [ "$BOARD_TYPE" == "esp" ]; then
  bash create-esp-device.sh $BOARD_TYPE $GROUP_NAME $PROJECT_NAME $DEVICE_LABEL $DEVICE_NAME $PORT || exit 1
else
  bash create-arduino-device.sh $BOARD_TYPE $GROUP_NAME $PROJECT_NAME $DEVICE_LABEL $DEVICE_NAME $PORT || exit 1
fi


echo ""
echo "Marking device as connected..."
echo "1" > "devices/$DEVICE_NAME/is-usb-connected.txt"

sh run-background.sh bash mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Connected"

sh run-background.sh bash notify-send.sh "Finished connecting $GROUP_NAME device"

HOST=$(cat /etc/hostname)

bash run-background.sh bash create-message-file.sh "$DEVICE_NAME connected"

bash send-email.sh "Device $DEVICE_NAME connected via USB (on $HOST)." "The $DEVICE_NAME device was connected via USB on host $HOST."

echo ""
echo "Finished auto connecting device."

