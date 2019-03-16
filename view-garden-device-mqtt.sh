DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

GROUP=$(cat "devices/$DEVICE_NAME/group.txt")

# Soil moisture monitor
if [ "$GROUP" = "monitor" ]; then
  sh view-garden-monitor-device-mqtt.sh $DEVICE_NAME
fi

# Irrigator
if [ "$GROUP" = "irrigator" ]; then
  sh view-garden-irrigator-device-mqtt.sh $DEVICE_NAME
fi

# Illuminator
if [ "$GROUP" = "illuminator" ]; then
  sh view-garden-illuminator-device-mqtt.sh $DEVICE_NAME
fi

# Ventilator
if [ "$GROUP" = "ventilator" ]; then
  sh view-garden-ventilator-device-mqtt.sh $DEVICE_NAME
fi
