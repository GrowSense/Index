
# Example:
# sh upload-monitor-sketch-esp.sh "mymonitor" ttyUSB0

DIR=$PWD

MOCK_FLAG_FILE="is-mock-setup.txt"
MOCK_HARDWARE_FLAG_FILE="is-mock-hardware.txt"

IS_MOCK_SETUP=0
IS_MOCK_HARDWARE=0

if [ -f "$MOCK_FLAG_FILE" ]; then
  IS_MOCK_SETUP=1
  echo "Is mock setup"
fi

if [ -f "$MOCK_HARDWARE_FLAG_FILE" ]; then
  IS_MOCK_HARDWARE=1
  echo "Is mock hardware"
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

echo "Uploading monitor ESP8266 sketch"

echo "Serial port: $SERIAL_PORT"

BASE_PATH="sketches/monitor/SoilMoistureSensorCalibratedSerialESP"

cd $BASE_PATH

# Pull the security files from the index into the project
sh pull-security-files.sh && \

# Inject security details
sh inject-security-settings.sh && \

# Inject device name
sh inject-device-name.sh "$DEVICE_NAME" && \

# Inject version into the sketch
sh inject-version.sh && \

# Build the sketch
sh build.sh || exit 1

# Upload the sketch
if [ $IS_MOCK_HARDWARE = 0 ]; then
    sh upload.sh "/dev/$SERIAL_PORT" || exit 1
else
    echo "[mock] sh upload.sh /dev/$SERIAL_PORT"
fi

# Clean all settings
sh clean-settings.sh && \

cd $DIR && \

if [ $IS_MOCK_HARDWARE = 0 ]; then
    sh $BASE_PATH/monitor-serial.sh "/dev/$SERIAL_PORT" || exit 1
else
    echo "[mock] sh monitor-serial.sh /dev/$SERIAL_PORT"
fi

echo "Finished upload"
