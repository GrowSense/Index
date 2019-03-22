echo ""
echo "Removing garden device configuration"
echo ""

DEVICE_NAME=$1

BOARD_TYPE=$(cat "devices/$DEVICE_NAME/board.txt")

if [ ! $DEVICE_NAME ]; then
  echo "Error: Specify a device name as an argument."
else
  echo "Device name: $DEVICE_NAME"

  sh remove-device-services.sh $DEVICE_NAME || exit 1

  # Only remove it from the system completely if it's NOT an ESP/WiFi board. They can keep running without a USB connection.
  if [ $BOARD_TYPE != "esp" ]; then
    echo "This is an USB based microcontroller. It is being removed from the system completely."
    
    echo "Removing device info"
    DEVICE_INFO_DIR="devices/$DEVICE_NAME"
    if [ -d $DEVICE_INFO_DIR ]; then
      rm $DEVICE_INFO_DIR -R
    fi
    
    # Recreating garden UI
    # TODO: Instead of regenerating the entire UI, figure out how to remove a single item from the UI
    sh recreate-garden-ui.sh || exit 1
  else
    echo "This is an ESP/WiFi based microcontroller. It is still in the system and can run without a USB connection."
  fi
  

  echo "Garden device removed: $DEVICE_NAME"
fi
