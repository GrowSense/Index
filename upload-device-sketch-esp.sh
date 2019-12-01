
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

  echo ""
  echo "  Pulling security files..."
  sh pull-security-files.sh || exit 1

  # Inject version into the sketch
  sh inject-version.sh || exit 1

  # Upload the sketch
  if [ "$IS_MOCK_HARDWARE" != "1" ]; then
      echo "  Uploading (please wait)..."
      bash upload.sh /dev/$SERIAL_PORT
  else
      echo "[mock] sh upload.sh /dev/$SERIAL_PORT"
  fi

  # TODO: Clean up obsolete code
  #echo "  Exit code: $?"
  
  #echo ""
  #echo "-------------------- Output --------------------"
  #echo "${RESULT}"
  #echo "--------------------------------------------------"
  #echo ""

  
  #if [[ $(echo $RESULT) =~ "SUCCESS" ]] || [[ $(echo $RESULT) =~ "Upload complete" ]]; then
  if [[ "$?" == "0" ]]; then
    echo "  Upload successful"

    echo "  Giving device time to load..."
    sleep 5

    bash send-wifi-mqtt-commands.sh "/dev/$SERIAL_PORT" || exit 1

    cd $DIR

    bash send-device-name-command.sh $DEVICE_NAME "/dev/$SERIAL_PORT" || exit 1

    bash report-device-uploaded.sh $DEVICE_NAME "esp" $DEVICE_GROUP $SERIAL_PORT || exit 1
  else
    echo "  Error: Upload failed!"
    cd $DIR

    bash report-device-upload-failed.sh $DEVICE_NAME "esp" $DEVICE_GROUP $SERIAL_PORT || exit 1
    
    exit 1
  fi

  echo "Finished uploading $DEVICE_GROUP ESP/WiFi sketch"
  echo ""
else
  echo "Sketch is already uploading. Skipping."
  echo ""
fi
