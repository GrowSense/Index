
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
  echo "Specify the device name as an argument."
  exit 1
fi

echo ""
echo "Uploading irrigator ESP sketch"

echo "  Device name: $DEVICE_NAME"
echo "  Serial port: $SERIAL_PORT"

BASE_PATH="$PWD/sketches/irrigator/SoilMoistureSensorCalibratedPumpESP"

IS_ALREADY_UPLOADING=0

if [ -f "devices/$DEVICE_NAME/is-uploading.txt" ]; then
  IS_ALREADY_UPLOADING=$(cat "devices/$DEVICE_NAME/is-uploading.txt")
fi

echo "  Is already uploading: $IS_ALREADY_UPLOADING"

if [ "$IS_ALREADY_UPLOADING" = "0" ]; then

  sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Uploading" || echo "Failed to publish status to MQTT"

  if [ -d "devices/$DEVICE_NAME" ]; then
    echo ""
    echo "  Setting device is-uploading.txt flag file to 1 (true)..."
    echo "1" > "devices/$DEVICE_NAME/is-uploading.txt"
  fi

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

  # TODO: Remove if not needed. Build is performed during upload.

  # Build the sketch
  #if [ $IS_MOCK_SUBMODULE_BUILDS = 0 ]; then
  #    sh build.sh || exit 1
  #else
  #    echo "[mock] sh build.sh"
  #fi

  # Upload the sketch
  if [ $IS_MOCK_HARDWARE = 0 ]; then
      sh upload.sh "/dev/$SERIAL_PORT"
  else
      echo "[mock] sh upload.sh /dev/$SERIAL_PORT"
  fi

  # Note: Clean disabled because it messes with tests
  # Clean all settings
  #sh clean-settings.sh && \

  cd $DIR && \

  # TODO: Clean up. Disabled because it's causing problems with plug and play
  #if [ $IS_MOCK_HARDWARE = 0 ]; then
  #    sh $BASE_PATH/monitor-serial.sh "/dev/$SERIAL_PORT" || exit 1
  #else
  #    echo "[mock] sh monitor-serial.sh /dev/$SERIAL_PORT"
  #fi


  if [ -d "devices/$DEVICE_NAME" ]; then
    if [ $? = 0 ]; then
      echo ""
      echo "  Setting device is-uploaded.txt flag file to 1 (true)..."
      echo "1" > "devices/$DEVICE_NAME/is-uploaded.txt"
    else
      echo "  Setting device is-uploaded.txt flag file to 0 (false)..."
      echo "0" > "devices/$DEVICE_NAME/is-uploaded.txt"
    fi
    echo ""
    echo "  Setting device is-uploading.txt flag file to 0 (false)..."
    echo "0" > "devices/$DEVICE_NAME/is-uploading.txt"
  fi

  if [ $? = 0 ]; then
    sh notify-send.sh "$DEVICE_NAME" "Irrigator ESP/WiFi sketch uploaded"

    sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Uploaded" || echo "Failed to publish status to MQTT"
  else
    sh notify-send.sh "$DEVICE_NAME" "Irrigator ESP/WiFi sketch upload failed"

    sh mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Upload failed" || echo "Failed to publish status to MQTT"
    
    exit 1
  fi

  echo "Finished uploading irrigator ESP/WiFi sketch"
  echo ""
else
  echo "Sketch is already uploading. Skipping."
  echo ""
fi
