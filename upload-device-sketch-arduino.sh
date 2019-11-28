
# Example:
# sh upload-device-sketch-arduino.sh [Board] [Group] [Project] [DeviceName] [Port]

DIR=$PWD

DEVICE_BOARD=$1
DEVICE_GROUP=$2
DEVICE_PROJECT=$3
DEVICE_NAME=$4
SERIAL_PORT=$5

if [ ! $DEVICE_BOARD ]; then
  echo "Please provide a device board as an argument."
  exit 1
fi

if [ ! $DEVICE_GROUP ]; then
  echo "Please provide a device group as an argument."
  exit 1
fi

if [ ! $DEVICE_PROJECT ]; then
  echo "Please provide a device project as an argument."
  exit 1
fi

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

echo ""
echo "Uploading arduino sketch"

echo "  Device name: $DEVICE_NAME"
echo "  Device board: $DEVICE_BOARD"
echo "  Device group: $DEVICE_GROUP"
echo "  Device project: $DEVICE_PROJECT"
echo "  Serial port: $SERIAL_PORT"

PROJECT_PATH="$PWD/sketches/$DEVICE_GROUP/$DEVICE_PROJECT"

[[ ! -d $PROJECT_PATH ]] && echo "Project directory not found:" && echo "  $PROJECT_PATH" && exit 1

[[ -f "is-mock-hardware.txt" ]] && IS_MOCK_HARDWARE=$(cat "is-mock-hardware.txt") && echo "Is mock hardware"

[[ -f "devices/$DEVICE_NAME/is-uploading.txt" ]] && IS_ALREADY_UPLOADING=$(cat "devices/$DEVICE_NAME/is-uploading.txt")

if [ "$IS_ALREADY_UPLOADING" != "1" ]; then

  sh report-device-uploading.sh $DEVICE_NAME $DEVICE_BOARD $DEVICE_GROUP $SERIAL_PORT || exit 1
  
  cd $PROJECT_PATH
  
  echo "  Project directory:"
  echo "    $PROJECT_PATH"

  # Inject version into the sketch
  sh inject-version.sh || exit 1

  # Inject board type into the sketch (used for device discovery)
  if [ -f "inject-board-type.sh" ]; then
    sh inject-board-type.sh "$DEVICE_BOARD" || exit 1
  fi

  # Upload the sketch
  if [ "$IS_MOCK_HARDWARE" != "1" ]; then
      echo "  Uploading (please wait)..."
      RESULT=$(bash upload-$DEVICE_BOARD.sh "/dev/$SERIAL_PORT")
  else
      echo "[mock] sh upload-$DEVICE_BOARD.sh /dev/$SERIAL_PORT"
  fi

  echo ""
  echo "${RESULT}"
  echo ""

  cd $DIR

  if [[ $(echo $RESULT) =~ "SUCCESS" ]] || [[ $(echo $RESULT) =~ "Upload complete" ]]; then  
    bash send-device-name-command.sh $DEVICE_NAME $SERIAL_PORT || exit 1
    bash report-device-uploaded.sh $DEVICE_NAME $DEVICE_BOARD $DEVICE_GROUP $SERIAL_PORT || exit 1
  else
    bash report-device-upload-failed.sh $DEVICE_NAME $DEVICE_BOARD $DEVICE_GROUP $SERIAL_PORT || exit 1
    
    exit 1
  fi

  echo "Finished uploading $DEVICE_GROUP $DEVICE_BOARD sketch"
  echo ""
else
  echo "Sketch is already uploading. Skipping."
  echo ""
fi
