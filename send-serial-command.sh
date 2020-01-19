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

exec 3<> $SERIAL_PORT

sleep 2

echo "$COMMAND" >&3

sleep 1

#RESULT=$(cat <&3)

#echo ""
#echo "-------------------- Device Output --------------------"
#echo ""
#echo "${RESULT}"
#echo ""
#echo "-------------------------------------------------------"
#echo ""

#if [[ "$RESULT" != *"$COMMAND"* ]]; then
#  echo "  Error: Device didn't receive command."
#  exit 1
#fi

exec 3>&-

echo "Finished sending command to device via serial"
