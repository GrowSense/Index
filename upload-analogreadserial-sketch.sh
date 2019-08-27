
# Example:
# sh upload-analogreadserial-sketch.sh 0 ttyUSB0

DIR=$PWD

INPUT_PIN=$1
SERIAL_PORT=$2

if [ ! $INPUT_PIN ]; then
  INPUT_PIN="A0"
fi

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

echo "Uploading AnalogReadSerial sketch"

echo "Input pin: $INPUT_PIN"
echo "Serial port: $SERIAL_PORT"

BASE_PATH="sketches/util/AnalogReadSerial"

cd $BASE_PATH

SKETCH_PATH="src/AnalogReadSerial/AnalogReadSerial.ino"

sed -i "s/int inputPin = .*/int inputPin = $INPUT_PIN;/" $SKETCH_PATH && \

# Build the sketch
sh build.sh && \

# Upload the sketch
sh upload.sh "/dev/$SERIAL_PORT" && \

# Restore the original sketch
git checkout $SKETCH_PATH

cd $DIR

sh $BASE_PATH/monitor-serial.sh "/dev/$SERIAL_PORT"

