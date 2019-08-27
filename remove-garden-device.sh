echo ""
echo "Removing garden device"
echo ""

DEVICE_NAME=$1

SYSTEMCTL_SCRIPT="systemctl.sh"

if [ ! $DEVICE_NAME ]; then
  echo "Error: Specify a device name as an argument."
else
  echo "Device name: $DEVICE_NAME"

  sh remove-device-services.sh $DEVICE_NAME || exit 1 
  
  echo "Removing device info"
  DEVICE_INFO_DIR="devices/$DEVICE_NAME"
  if [ -d $DEVICE_INFO_DIR ]; then
    rm $DEVICE_INFO_DIR -R
  fi
  
  # Remove from mobile UI
  #  cd mobile/linearmqtt/ && \
  #  sh remove-garden-monitor-ui.sh $DEVICE_NAME && \
  #  cd $DIR

  echo "Garden device removed: $DEVICE_NAME"
fi
