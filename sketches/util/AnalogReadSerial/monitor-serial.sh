PORT_NAME=$1

if [ ! $PORT_NAME ]; then
  PORT_NAME="/dev/ttyUSB0"
fi

echo "Port: $PORT_NAME"

pio device monitor --port $PORT_NAME
