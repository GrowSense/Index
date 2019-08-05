BOARD_TYPE=$1
FAMILY_NAME=$2
GROUP_NAME=$3
PROJECT_NAME=$4
SCRIPT_CODE=$5
PORT=$6

EXAMPLE="Example:\n\tauto-connect-device.sh [BoardType] [ProjectFamily] [ProjectGroup] [ProjectName] [ScriptCode] [Port]"

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

# Disabled to speed up plug and play. But might cause problems if it's disabled. The supervisor script should take care of this.
#echo "Pulling device info from remote garden computer..."
#sh pull-device-info-from-remotes.sh || exit 1

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

sh run-background.sh sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Connecting"

echo "Device name: $DEVICE_NAME"
echo "Device number: $DEVICE_NUMBER"

echo "Device info dir:"
echo "  $DEVICE_INFO_DIR"

DEVICE_LABEL="$(echo $DEVICE_NAME | sed 's/.*/\u&/')" || exit 1

SCRIPT_NAME="create-garden-$SCRIPT_CODE-$BOARD_TYPE".sh || exit 1
echo "" && \
echo "Add device script:" && \
echo $SCRIPT_NAME "$DEVICE_LABEL" "$DEVICE_NAME" $PORT || exit 1
echo "" && \
sh run-background.sh sh $SCRIPT_NAME "$DEVICE_LABEL" "$DEVICE_NAME" $PORT || exit 1

sh run-background.sh sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Connected"

echo ""
echo "Finished auto connecting device."

sh notify-send.sh "Finished adding $GROUP_NAME device"
