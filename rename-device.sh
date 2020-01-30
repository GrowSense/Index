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

CURRENT_HOST=$(cat /etc/hostname) || exit 1

echo "  Current host: $CURRENT_HOST"

DEVICE_HOST=$(cat devices/$ORIGINAL_NAME/host.txt) || exit 1

echo ""
echo "  Original name: $ORIGINAL_NAME"
echo "  New name: $NEW_NAME"

if [ "$DEVICE_HOST" = "$CURRENT_HOST" ]; then
  echo ""
  echo "  Device is on current host..."
  DEVICE_PORT=$(cat devices/$ORIGINAL_NAME/port.txt)

  echo "  Port: $DEVICE_PORT"

  echo ""
  echo "  Removing device services..."
  bash remove-garden-device-services.sh $ORIGINAL_NAME || exit 1

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
  echo "  Creating device services..."
  bash create-garden-device-services.sh $NEW_NAME || exit 1
else
  echo ""
  echo "  Device is on remote host..."
  
  . ./get-remote-name.sh $DEVICE_HOST || exit 1

  bash run-on-remote.sh $REMOTE_NAME bash rename-device.sh $ORIGINAL_NAME $NEW_NAME || exit 1

  echo ""
  echo "  Renaming device folder..."
  mv "devices/$ORIGINAL_NAME" "devices/$NEW_NAME" || exit 1

  echo ""
  echo "  Setting device name in name.txt file..."
  echo "$NEW_NAME" > "devices/$NEW_NAME/name.txt" || exit 1
fi


echo ""
echo "Finished renaming device."
