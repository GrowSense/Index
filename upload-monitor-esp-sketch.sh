
# Example:
# sh upload-monitor-sketch-esp.sh ttyUSB0

DIR=$PWD

MOCK_FLAG_FILE="is-mock-setup.txt"
IS_MOCK_SETUP=0
if [ -f "$MOCK_FLAG_FILE" ]; then
    IS_MOCK_SETUP=1
fi

SERIAL_PORT=$1

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

echo "Uploading monitor ESP8266 sketch"

echo "Serial port: $SERIAL_PORT"

BASE_PATH="sketches/monitor/SoilMoistureSensorCalibratedSerialESP"

cd $BASE_PATH

# Inject version into the sketch
sh inject-version.sh && \

# Build the sketch
sh build.sh || exit 1

# Upload the sketch
if [ ! $IS_MOCK_SETUP ]; then
    sh upload.sh "/dev/$SERIAL_PORT" || exit 1
else
    echo "[mock] sh upload.sh /dev/$SERIAL_PORT"
fi

cd $DIR && \

if [ ! $IS_MOCK_SETUP ]; then
    sh $BASE_PATH/monitor-serial.sh "/dev/$SERIAL_PORT" || exit 1
else
    echo "[mock] sh monitor-serial.sh /dev/$SERIAL_PORT"
fi

echo "Finished upload"