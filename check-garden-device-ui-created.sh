NAME=$1

if [ ! $NAME ]; then
  echo "Provide a device name as an argument."
  exit 1
fi

echo "Checking whether device has been added to the UI yet..."

echo "Name: $NAME"

DEVICE_INFO_DIR="$PWD/devices/$NAME"


IS_DEVICE_UI_CREATED_FLAG_FILE="$DEVICE_INFO_DIR/is-ui-created.txt"
IS_DEVICE_UI_CREATED=0
if [ -f $IS_DEVICE_UI_CREATED_FLAG_FILE ]; then
  IS_DEVICE_UI_CREATED=$(cat "$IS_DEVICE_UI_CREATED_FLAG_FILE")
  echo "Device has already been added."
else
  echo "Device hasn't been added yet"
fi

