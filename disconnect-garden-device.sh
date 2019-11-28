echo ""
echo "Disconnecting garden device..."
echo ""

DEVICE_NAME=$1

BOARD_TYPE=$(cat "devices/$DEVICE_NAME/board.txt")

if [ ! $DEVICE_NAME ]; then
  echo "Error: Specify a device name as an argument."
  exit 1
else
  echo "  Device name: $DEVICE_NAME"
  echo "  Board type: $BOARD_TYPE"

  sh remove-device-services.sh $DEVICE_NAME || exit 1
  
  DEVICE_INFO_DIR="devices/$DEVICE_NAME"

# TODO: Remove obsolete code. Device info is now kept on USB boards but marked as disconnected
  # Check whether it's a WiFi device
#  [ "$BOARD_TYPE" = "esp" ] \
#    && IS_WIFI=1 \
#    || IS_WIFI=0

  # Only remove it from the system completely if it's NOT an ESP/WiFi board. They can keep running without a USB connection.
#  if [ $IS_WIFI = 1 ]; then
#    echo "  WiFi based device. Device will remain registered but marked as disconnected."
    echo "  Marking device and disconnected from USB"
    echo "0" > "$DEVICE_INFO_DIR/is-usb-connected.txt"
#  else
#    echo "  USB based device. It is being removed from the system completely."
    
#    echo "  Removing device info.."
#    if [ -d $DEVICE_INFO_DIR ]; then
#      rm $DEVICE_INFO_DIR -R
#    fi
    
    # Recreating garden UI
    # TODO: Remove if not needed. The Linear MQTT Dashboard app is being phased out
    #sh recreate-garden-ui.sh || exit 1
#  fi
  

  echo "Garden device removed: $DEVICE_NAME"
fi
