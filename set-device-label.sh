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

echo "Device name: $1"
echo "Device label: $2"

echo "$DEVICE_LABEL" > "devices/$DEVICE_NAME/label.txt"

echo "Finished setting device label."