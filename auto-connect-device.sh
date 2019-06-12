BOARD_TYPE=$1
FAMILY_NAME=$2
GROUP_NAME=$3
PROJECT_NAME=$4
PORT=$5

EXAMPLE="Example:\n\t...sh [BoardType] [ProjectFamily] [ProjectGroup] [ProjectName] [Port]"

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
if [ ! $PORT ]; then
  echo "Provide a port as an argument."
  echo $EXAMPLE
  exit 1
fi

echo "Automatically adding a device..."

# Disabled because it's causing problems with tests
#notify-send "Adding $GROUP_NAME device"

#sh update.sh

DEVICE_NUMBER=1

# TODO: Remove if not needed. It shouldn't be needed. Only if plug and play isn't reliable enough at removing devices
#sh clean-disconnected-devices.sh || "Failed to clean disconnected devices."

echo "Pulling device info from remote indexes..."
sh pull-device-info-from-remotes.sh || exit 1

DEVICE_INFO_DIR="devices/$GROUP_NAME$DEVICE_NUMBER"
    
if [ -d "$DEVICE_INFO_DIR" ]; then

  echo "Device exists"
  
  until [ ! -d "$DEVICE_INFO_DIR" ]; do
    echo "Increasing device number"
    DEVICE_NUMBER=$((DEVICE_NUMBER+1))
    DEVICE_INFO_DIR="devices/$GROUP_NAME$DEVICE_NUMBER"
    echo "Device info dir:"
    echo $DEVICE_INFO_DIR
  done
fi

DEVICE_POSTFIX=""

if [ $BOARD_TYPE = "esp" ]; then
  DEVICE_POSTFIX="W"
fi

DEVICE_NAME="$GROUP_NAME$DEVICE_POSTFIX$DEVICE_NUMBER"

nohup sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Connecting" &

echo "Device name: $DEVICE_NAME"
echo "Device number: $DEVICE_NUMBER"

# FAST argument tells the create device script to execute long running processes in the background.
# This speeds up the plug and play system for WiFi/ESP based devices which require the sketch to be uploaded to set the WiFi details
FAST=""
if [ $BOARD_TYPE = "esp" ]; then
  FAST="fast"
fi

echo "Device info dir:"
echo "  $DEVICE_INFO_DIR"

DEVICE_LABEL="$(echo $DEVICE_NAME | sed 's/.*/\u&/')" || exit 1

SCRIPT_NAME="create-garden-$GROUP_NAME-$BOARD_TYPE".sh || exit 1
echo "" && \
echo "Add device script:" && \
echo $SCRIPT_NAME "$DEVICE_LABEL" "$DEVICE_NAME" $PORT $FAST || exit 1
echo "" && \
sh $SCRIPT_NAME "$DEVICE_LABEL" "$DEVICE_NAME" $PORT $FAST || exit 1

# Disabled because the plug and play system should take care of removing the device
#(echo "An error occurred when connecting device" && sh remove-garden-device.sh && exit 1)

nohup sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Connected" &

echo "Finished auto connecting device."

# Disabled because it's causing problems with tests
#notify-send "Finished adding $GROUP_NAME device"
