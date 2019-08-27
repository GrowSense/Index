DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please provide a device name as parameter"
else
  sh journalctl.sh -u greensense-ui-1602-$DEVICE_NAME.service $2 $3
fi
