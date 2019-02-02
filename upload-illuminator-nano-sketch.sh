
# Example:
# sh upload-illuminator-sketch.sh ttyUSB0

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

SERIAL_PORT=$1

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

echo "Uploading illuminator sketch"

echo "Serial port: $SERIAL_PORT"

BASE_PATH="sketches/illuminator/TemperatureHumidityDHTSensorFan"

cd $BASE_PATH

# Inject version into the sketch
sh inject-version.sh && \

# Build the sketch
if [ $IS_MOCK_SUBMODULE_BUILDS = 0 ]; then
    sh build-nano.sh || exit 1
else
    echo "[mock] sh build-nano.sh"
fi

# Upload the sketch
if [ $IS_MOCK_HARDWARE = 0 ]; then
    sh upload-nano.sh "/dev/$SERIAL_PORT" || exit 1
else
    echo "[mock] sh upload-nano.sh /dev/$SERIAL_PORT"
fi

cd $DIR

if [ $IS_MOCK_HARDWARE = 0 ]; then
  sh $BASE_PATH/monitor-serial.sh "/dev/$SERIAL_PORT" || exit 1
else
  echo "[mock] sh monitor-serial.sh /dev/$SERIAL_PORT"
fi

