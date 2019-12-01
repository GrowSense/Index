echo "Renaming device..."

ORIGINAL_NAME=$1
NEW_NAME=$2

if [ ! "$ORIGINAL_NAME" ]; then
  echo "  Error: Please provide the original name of the device as an argument."
  exit 1
fi

if [ ! "$NEW_NAME" ]; then
  echo "  Error: Please provide the new name of the device as an argument."
  exit 1
fi

if [ ! -d "devices/$ORIGINAL_NAME" ]; then
  echo "  Error: The device '$ORIGINAL_NAME' doesn't exist."
  exit 1
fi

if [ -d "devices/$NEW_NAME" ]; then
  echo "  Error: The device '$NEW_NAME' already exists."
  exit 1
fi

DEVICE_PORT=$(cat devices/$ORIGINAL_NAME/port.txt)

echo "  Original name: $ORIGINAL_NAME"
echo "  New name: $NEW_NAME"
echo "  Port: $DEVICE_PORT"

echo ""
echo "  Sending device name command to device..."
bash send-device-name-command.sh $NEW_NAME $DEVICE_PORT || exit 1

echo ""
echo "  Renaming device folder..."
mv "devices/$ORIGINAL_NAME" "devices/$NEW_NAME" || exit 1

echo ""
echo "  Setting device name in name.txt file..."
echo "$NEW_NAME" > "devices/$NEW_NAME/name.txt" || exit 1

echo ""
echo "Finished renaming device."
