echo ""
echo "Starting garden device services"
echo ""

DIR=$PWD

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please specify a device name as an argument."
else

  echo "Device name: $DEVICE_NAME"
  
  DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")
  
  echo "Device group: $DEVICE_GROUP"
  
  if [ "$DEVICE_GROUP" = "ui" ]; then
  
    echo "Restart UI controller service" && \
    sh systemctl.sh start greensense-ui-1602-$DEVICE_NAME.service || exit 1
    
  else

    echo "Restart MQTT bridge service" && \
    sh systemctl.sh start greensense-mqtt-bridge-$DEVICE_NAME.service || exit 1

  fi
  
  echo "Garden device services started for '$DEVICE_NAME'"
fi
