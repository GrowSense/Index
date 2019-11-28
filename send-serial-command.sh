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

echo "  Command: $COMMAND"
echo "  Device port: $SERIAL_PORT"

exec 3<> $SERIAL_PORT

echo "$COMMAND" >&3

exec 3>&-

echo "Finished sending command to device via serial"
