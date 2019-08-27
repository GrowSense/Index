PORT_NAME=$1

if [ ! $PORT_NAME ]; then
  PORT_NAME="/dev/ttyUSB0"
fi

echo "Port: $PORT_NAME"

#pio run --target upload --upload-port $PORT_NAME

#pio run --target upload --environment uno --upload-port $PORT_NAME
pio run --target upload --environment nanoatmega328 --upload-port $PORT_NAME

#pio run --target upload --environment uno --upload-port /dev/ttyUSB3
