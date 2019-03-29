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

DEVICE_NAME="$GROUP_NAME$DEVICE_NUMBER"

sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Connecting"

echo "Device name: $DEVICE_NAME"
echo "Device number: $DEVICE_NUMBER"

echo "Device info dir:"
echo $DEVICE_INFO_DIR

DEVICE_LABEL="$(echo $DEVICE_NAME | sed 's/.*/\u&/')" && \

SCRIPT_NAME="create-garden-$GROUP_NAME-$BOARD_TYPE".sh && \
echo "" && \
echo "Add device script:" && \
echo $SCRIPT_NAME "$DEVICE_LABEL" "$DEVICE_NAME" $PORT && \
echo "" && \
sh $SCRIPT_NAME "$DEVICE_LABEL" "$DEVICE_NAME" $PORT ||
(echo "An error occurred when connecting device" && sh remove-garden-device.sh && exit 1)

sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Connected"

echo "Finished auto connecting device."

# Disabled because it's causing problems with tests
#notify-send "Finished adding $GROUP_NAME device"
