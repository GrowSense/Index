
# Example:
# sh upload-irrigator-sketch.sh ttyUSB0

DIR=$PWD

SERIAL_PORT=$1

if [ ! $SERIAL_PORT ]; then
  SERIAL_PORT="ttyUSB0"
fi

echo "Uploading irrigator sketch"

echo "Serial port: $SERIAL_PORT"

BASE_PATH="sketches/irrigator/SoilMoistureSensorCalibratedPump"

cd $BASE_PATH

SKETCH_PATH="src/SoilMoistureSensorCalibratedPump/SoilMoistureSensorCalibratedPump.ino"

# Build the sketch
sh build.sh && \

# Upload the sketch
sh upload.sh "/dev/$SERIAL_PORT"

cd $DIR

sh $BASE_PATH/monitor-serial.sh "/dev/$SERIAL_PORT"

