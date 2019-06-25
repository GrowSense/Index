LOOP_NUMBER=$1
DEVICE_NAME=$2

EXAMPLE="Example:\n\tsh supervise-device.sh [LoopNumber] [DeviceName]"

echo "Supervising garden device..."

if [ ! $LOOP_NUMBER ]; then
  echo "Please provide a loop number as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  echo $EXAMPLE
  exit 1
fi

echo "  Loop number: $LOOP_NUMBER"
echo "  Device name: $DEVICE_NAME"


STATUS_CHECK_FREQUENCY=$(cat supervisor-status-check-frequency.txt)

if [ "$(( $LOOP_NUMBER%$STATUS_CHECK_FREQUENCY ))" -eq "0" ]; then
  sh supervise-device-status.sh $DEVICE_NAME
fi
