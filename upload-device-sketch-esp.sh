
# Example:
# sh upload-sketch-esp.sh "irrigator" "SoilMoistureSensorCalibratedPumpESP" "myirrigator" ttyUSB0

DIR=$PWD

DEVICE_GROUP=$1
DEVICE_PROJECT=$2
DEVICE_NAME=$3
SERIAL_PORT=$4

if [ ! $DEVICE_GROUP ]; then
  echo "Please provide a device group as an argument."
  exit 1
fi

if [ ! $DEVICE_PROJECT ]; then
  echo "Please provide a device project as an argument."
  exit 1
fi

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="NewWiFiIrrigator"
fi

echo ""
echo "Uploading $DEVICE_GROUP ESP sketch"

echo "  Device name: $DEVICE_NAME"
echo "  Device project: $DEVICE_PROJECT"
echo "  Serial port: $SERIAL_PORT"

PROJECT_PATH="$PWD/sketches/$DEVICE_GROUP/$DEVICE_PROJECT"

[[ ! -d $PROJECT_PATH ]] && echo "Project directory not found:" && echo "  $PROJECT_PATH" && exit 1

[[ -f "is-mock-hardware.txt" ]] && IS_MOCK_HARDWARE=$(cat "is-mock-hardware.txt") && echo "Is mock hardware"

[[ -f "devices/$DEVICE_NAME/is-uploading.txt" ]] && IS_ALREADY_UPLOADING=$(cat "devices/$DEVICE_NAME/is-uploading.txt")

if [ "$IS_ALREADY_UPLOADING" != "1" ]; then

  sh report-device-uploading.sh $DEVICE_NAME "esp" $DEVICE_GROUP $SERIAL_PORT

  cd "$PROJECT_PATH"

  echo "  Project directory:"
  echo "    $PROJECT_PATH"

  # Pull the security files from the index into the project
  sh pull-security-files.sh && \

  # Inject security details
  sh inject-security-settings.sh && \

  # Inject device name
  sh inject-device-name.sh "$DEVICE_NAME" && \

  # Inject version into the sketch
  sh inject-version.sh && \

  # Upload the sketch
  if [ "$IS_MOCK_HARDWARE" != "1" ]; then
      echo "  Uploading (please wait)..."
      RESULT=$(bash upload.sh "/dev/$SERIAL_PORT")
  else
      echo "[mock] sh upload.sh /dev/$SERIAL_PORT"
  fi

  echo ""
  echo "${RESULT}"
  echo ""

  cd $DIR
  
  if [[ $(echo $RESULT) =~ "SUCCESS" ]]; then  
    sh report-device-uploaded.sh $DEVICE_NAME "esp" $DEVICE_GROUP $SERIAL_PORT
  else
    sh report-device-upload-failed.sh $DEVICE_NAME "esp" $DEVICE_GROUP $SERIAL_PORT
    
    exit 1
  fi

  echo "Finished uploading $DEVICE_GROUP ESP/WiFi sketch"
  echo ""
else
  echo "Sketch is already uploading. Skipping."
  echo ""
fi
