echo "Setting device label..."

DEVICE_NAME=$1
DEVICE_LABEL=$2

if [ ! "$DEVICE_NAME" ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

if [ ! "$DEVICE_LABEL" ]; then
  echo "Please provide a device label as an argument."
  exit 1
fi

echo "  Device name: $DEVICE_NAME"
echo "  Device label: $DEVICE_LABEL"

CURRENT_HOST="$(cat /etc/hostname)"

DEVICE_HOST="$(cat devices/$DEVICE_NAME/host.txt)"

echo "  Device host: $DEVICE_HOST"

if [ "$DEVICE_HOST" != "$CURRENT_HOST" ]; then

  echo ""
  echo "  Getting name of remote..."
  . ./get-remote-name.sh $DEVICE_HOST

  echo ""
  echo "  Setting device label on remote host..."
  echo ""
  bash run-on-remote.sh $REMOTE_NAME bash set-device-label.sh $DEVICE_NAME $DEVICE_HOST || exit 1

  echo ""
  echo "  Finished setting device label on remote host."
  echo ""
fi

echo "$DEVICE_LABEL" > "devices/$DEVICE_NAME/label.txt"

echo "Finished setting device label."