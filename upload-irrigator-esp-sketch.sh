
# Example:
# sh upload-irrigator-sketch-esp.sh "myirrigator" ttyUSB0

DIR=$PWD

MOCK_FLAG_FILE="is-mock-setup.txt"
MOCK_HARDWARE_FLAG_FILE="is-mock-hardware.txt"
MOCK_SUBMODULE_BUILDS_FLAG_FILE="is-mock-submodule-builds.txt"

IS_MOCK_SETUP=0
IS_MOCK_HARDWARE=0
IS_MOCK_SUBMODULE_BUILDS=0

IS_MOCK_SETUP=0
if [ -f "$MOCK_FLAG_FILE" ]; then
  IS_MOCK_SETUP=1
  echo "Is mock setup"
fi

if [ -f "$MOCK_HARDWARE_FLAG_FILE" ]; then
  IS_MOCK_HARDWARE=1
  echo "Is mock hardware"
fi

if [ -f "$MOCK_SUBMODULE_BUILDS_FLAG_FILE" ]; then
  IS_MOCK_SUBMODULE_BUILDS=1
  echo "Is mock submodule builds"
fi

DEVICE_NAME=$1
SERIAL_PORT=$2

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="NewWiFiIrrigator"
fi

echo ""
echo "Uploading irrigator ESP sketch"

echo "  Device name: $DEVICE_NAME"
echo "  Serial port: $SERIAL_PORT"

BASE_PATH="$PWD/sketches/irrigator/SoilMoistureSensorCalibratedPumpESP"

[[ -f "devices/$DEVICE_NAME/is-uploading.txt" ]] && IS_ALREADY_UPLOADING=$(cat "devices/$DEVICE_NAME/is-uploading.txt")

if [ "$IS_ALREADY_UPLOADING" != "1" ]; then

  sh report-device-uploading.sh $DEVICE_NAME

  cd "$BASE_PATH"

  echo "  Current directory:"
  echo "    $BASE_PATH"

  # Pull the security files from the index into the project
  sh pull-security-files.sh && \

  # Inject security details
  sh inject-security-settings.sh && \

  # Inject device name
  sh inject-device-name.sh "$DEVICE_NAME" && \

  # Inject version into the sketch
  sh inject-version.sh && \

  # Upload the sketch
  if [ $IS_MOCK_HARDWARE = 0 ]; then
      echo "  Uploading (please wait)..."
      RESULT=$(bash upload.sh "/dev/$SERIAL_PORT")
  else
      echo "[mock] sh upload.sh /dev/$SERIAL_PORT"
  fi

  cd $DIR
  
  if [[ $(echo $RESULT) =~ "Upload complete" ]]; then  
    sh report-device-uploaded.sh $DEVICE_NAME
  else
    sh report-device-upload-failed.sh $DEVICE_NAME
    
    exit 1
  fi

  echo "Finished uploading irrigator ESP/WiFi sketch"
  echo ""
else
  echo "Sketch is already uploading. Skipping."
  echo ""
fi
