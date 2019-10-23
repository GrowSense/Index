DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please provide a device name as parameter"
else
  sh systemctl.sh status growsense-ui-1602-$DEVICE_NAME.service
fi
