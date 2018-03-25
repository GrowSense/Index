DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please provode a device name as parameter"
else
  systemctl status greensense-updater-$DEVICE_NAME.service
fi
