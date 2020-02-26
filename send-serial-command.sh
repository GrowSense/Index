COMMAND=$1
SERIAL_PORT=$2

echo "Sending command to device via serial..."

if [ ! $COMMAND ]; then
  echo "Please provide a command as an argument."
  exit 1
fi

if [ ! $SERIAL_PORT ]; then
  echo "Please provide a serial port as an argument."
  exit 1
fi

if [[ "$SERIAL_PORT" != *"/dev/"* ]]; then
  SERIAL_PORT="/dev/$SERIAL_PORT"
fi

echo "  Command: '$COMMAND'"
echo "  Device port: $SERIAL_PORT"

stty -F $SERIAL_PORT 9600 cs8 -cstopb
sleep 0.1
echo "$COMMAND;" > $SERIAL_PORT

echo "Finished sending command to device via serial"
