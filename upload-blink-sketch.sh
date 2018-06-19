
# Example:
# sh upload-blink-sketch.sh 12 ttyUSB0

DIR=$PWD

LED_PIN=$1
SERIAL_PORT=$2

if [ ! $LED_PIN ]; then
  LED_PIN=13
fi

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

echo "Uploading blink sketch"

echo "LED pin: $LED_PIN"
echo "Serial port: $SERIAL_PORT"

BLINK_BASE_PATH="sketches/util/Blink/"

cd $BLINK_BASE_PATH

BLINK_SKETCH_PATH="src/Blink/Blink.ino"

sed -i "s/int ledPin = .*/int ledPin = $LED_PIN;/" $BLINK_SKETCH_PATH && \

# Build the sketch
sh build-nano.sh && \

# Upload the sketch
sh upload-nano.sh "/dev/$SERIAL_PORT" && \

# Restore the original sketch
git checkout $BLINK_SKETCH_PATH

cd $DIR
