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

echo "Automatically adding a device..."

# Disabled because it's causing problems with tests
sh notify-send.sh "Adding $GROUP_NAME device"

#sh update.sh

DEVICE_NUMBER=1

# TODO: Remove if not needed. It shouldn't be needed. Only if plug and play isn't reliable enough at removing devices
#sh clean-disconnected-devices.sh || "Failed to clean disconnected devices."

echo "Pulling device info from remote garden computer..."
sh pull-device-info-from-remotes.sh || exit 1

if [ ! $DEVICE_NAME ] || [[ $DEVICE_NAME == *"New"* ]] || [[ $DEVICE_NAME == "{DEVICENAME}" ]]; then
  DEVICE_POSTFIX=""

  if [ $BOARD_TYPE = "esp" ]; then
    DEVICE_POSTFIX="W"
  fi

  DEVICE_INFO_DIR="devices/$GROUP_NAME$DEVICE_POSTFIX$DEVICE_NUMBER"

  if [ -d "$DEVICE_INFO_DIR" ]; then

    echo "Device exists"
  
    until [ ! -d "$DEVICE_INFO_DIR" ]; do
      echo "Increasing device number"
      DEVICE_NUMBER=$((DEVICE_NUMBER+1))
      DEVICE_INFO_DIR="devices/$GROUP_NAME$DEVICE_POSTFIX$DEVICE_NUMBER"
      echo "Device info dir:"
      echo $DEVICE_INFO_DIR
    done
  fi

  DEVICE_NAME="$GROUP_NAME$DEVICE_POSTFIX$DEVICE_NUMBER"
fi

sh run-background.sh sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Connecting"

echo "Device name: $DEVICE_NAME"
echo "Device number: $DEVICE_NUMBER"

echo "Device info dir:"
echo "  $DEVICE_INFO_DIR"

DEVICE_LABEL="$(echo $DEVICE_NAME | sed 's/.*/\u&/')" || exit 1

SCRIPT_NAME="create-garden-$SCRIPT_CODE-$BOARD_TYPE".sh || exit 1
echo "" && \
echo "Create device script:" && \
echo $SCRIPT_NAME "$DEVICE_LABEL" "$DEVICE_NAME" $PORT || exit 1
echo "" && \
sh $SCRIPT_NAME "$DEVICE_LABEL" "$DEVICE_NAME" $PORT || exit 1

echo ""
echo "Marking device as connected..."
echo "1" > "devices/$DEVICE_NAME/is-usb-connected.txt"

sh run-background.sh sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Connected"

sh run-background.sh sh notify-send.sh "Finished connecting $GROUP_NAME device"

HOST=$(cat /etc/hostname)

bash create-message-file.sh "$DEVICE_NAME connected"

bash send-email.sh "Device $DEVICE_NAME connected via USB (on $HOST)." "The $DEVICE_NAME device was connected via USB on host $HOST."

echo ""
echo "Finished auto connecting device."

