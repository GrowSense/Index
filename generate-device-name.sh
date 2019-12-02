echo "Generating new device name..."

GROUP_NAME=$1
PROJECT_NAME=$2
BOARD_TYPE=$3

if [ ! "$GROUP_NAME" ]; then
  echo "  Error: Please provide a group name as an argument."
  exit 1
fi

if [ ! "$PROJECT_NAME" ]; then
  echo "  Error: Please provide a project name as an argument."
  exit 1
fi

if [ ! "$BOARD_TYPE" ]; then
  echo "  Error: Please provide a board type as an argument."
  exit 1
fi

DEVICE_POSTFIX=""
DEVICE_NUMBER=1

if [ "$BOARD_TYPE" = "esp" ]; then
  DEVICE_POSTFIX="W"
fi

if [ "$GROUP_NAME" == "monitor" ]; then
  [[ "$PROJECT_NAME" == *"Moisture"* ]] && DEVICE_NAME_START="moisture"
  [[ "$PROJECT_NAME" == *"Light"* ]] && DEVICE_NAME_START="light"
  [[ "$PROJECT_NAME" == *"TemperatureHumidity"* ]] && DEVICE_NAME_START="tempHumidity"
else
  DEVICE_NAME_START="$GROUP_NAME"
fi

DEVICE_INFO_DIR="devices/$DEVICE_NAME_START$DEVICE_POSTFIX$DEVICE_NUMBER"

if [ -d "$DEVICE_INFO_DIR" ]; then

  echo "Device exists"
 
  until [ ! -d "$DEVICE_INFO_DIR" ]; do
    echo "Increasing device number"
    DEVICE_NUMBER=$((DEVICE_NUMBER+1))
    DEVICE_INFO_DIR="devices/$DEVICE_NAME_START$DEVICE_POSTFIX$DEVICE_NUMBER"
    echo "Device info dir:"
    echo $DEVICE_INFO_DIR
  done
fi

DEVICE_NAME="$DEVICE_NAME_START$DEVICE_POSTFIX$DEVICE_NUMBER"

echo "  Device name: $DEVICE_NAME"

echo "Finished generating device name."