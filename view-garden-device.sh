DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

sh view-garden-device-mqtt.sh $DEVICE_NAME
