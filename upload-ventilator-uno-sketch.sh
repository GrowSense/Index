
# Example:
# sh upload-ventilator-sketch.sh ttyUSB0

DIR=$PWD

MOCK_FLAG_FILE="is-mock-setup.txt"
MOCK_HARDWARE_FLAG_FILE="is-mock-hardware.txt"
MOCK_SUBMODULE_BUILDS_FLAG_FILE="is-mock-submodule-builds.txt"

IS_MOCK_SETUP=0
IS_MOCK_HARDWARE=0
IS_MOCK_SUBMODULE_BUILDS=0

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

SERIAL_PORT=$1

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

echo "Uploading ventilator sketch"

echo "Serial port: $SERIAL_PORT"

BASE_PATH="$PWD/sketches/ventilator/TemperatureHumidityDHTSensorFan"

cd "$BASE_PATH"

echo "Current directory:"
echo $BASE_PATH

# Inject version into the sketch
sh inject-version.sh || exit 1

# TODO: Remove if not needed. Build is performed during upload.

# Build the sketch
#if [ $IS_MOCK_SUBMODULE_BUILDS = 0 ]; then
#    sh build-uno.sh || exit 1
#else
#    echo "[mock] sh build-uno.sh"
#fi

# Upload the sketch
if [ $IS_MOCK_HARDWARE = 0 ]; then
    sh upload-uno.sh "/dev/$SERIAL_PORT" || exit 1
else
    echo "[mock] sh upload-uno.sh /dev/$SERIAL_PORT"
fi

cd $DIR

# TODO: Clean up. Disabled because it's causing problems with plug and play
#if [ $IS_MOCK_HARDWARE = 0 ]; then
#  sh $BASE_PATH/monitor-serial.sh "/dev/$SERIAL_PORT" || exit 1
#else
#  echo "[mock] sh monitor-serial.sh /dev/$SERIAL_PORT"
#fi
