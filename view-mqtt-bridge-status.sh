DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please provide a device name as parameter"
else
  systemctl status greensense-mqtt-bridge-$DEVICE_NAME.service
fi
