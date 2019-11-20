LOOP_NUMBER=$1
DEVICE_NAME=$2

EXAMPLE="Example:\n\tsh supervise-device.sh [LoopNumber] [DeviceName]"

#echo "Supervising garden device..."

if [ ! $LOOP_NUMBER ]; then
  echo "Please provide a loop number as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  echo $EXAMPLE
  exit 1
fi

#echo "  Loop number: $LOOP_NUMBER"
#echo "  Device name: $DEVICE_NAME"

CURRENT_HOST=$(cat "/etc/hostname")
DEVICE_HOST=$(cat "devices/$DEVICE_NAME/host.txt")
DEVICE_GROUP=$(cat "devices/$DEVICE_GROUP/group.txt")

# TODO: Remove if not needed. The Linear MQTT Dashboard app is being phased out
# If it's not a UI device then create the Linear MQTT Dashboard UI configuration if it hasn't been created already
#if [ "$DEVICE_GROUP" != "ui" ]; then  
#  DEVICE_UI_IS_CREATED=0
#  if [ -f "devices/$DEVICE_NAME/is-ui-created.txt" ]; then 
#    DEVICE_UI_IS_CREATED=$(cat "devices/$DEVICE_NAME/is-ui-created.txt");
#  fi

#  if [ "$DEVICE_UI_IS_CREATED" = "0" ]; then
#    echo "  Device Linear MQTT Dashboard UI hasn't been created. Creating now..."

#    DEVICE_LABEL=$(cat "devices/$DEVICE_NAME/label.txt");
    
#    sh create-garden-$DEVICE_GROUP-ui.sh $DEVICE_LABEL $DEVICE_NAME || echo "  Failed to create device Linear MQTT Dashboard UI"  
#  fi
#fi


if [ "$DEVICE_HOST" = "$CURRENT_HOST" ]; then
    STATUS_CHECK_FREQUENCY=$(cat supervisor-status-check-frequency.txt)

    if [ "$(( $LOOP_NUMBER%$STATUS_CHECK_FREQUENCY ))" -eq "0" ]; then
        bash supervise-device-status.sh $DEVICE_NAME

        if [ -f "supervise-$DEVICE_GROUP-device-status.sh" ]; then
	  bash supervise-$DEVICE_GROUP-device-status.sh $DEVICE_NAME
        fi
    fi
else
    echo "  Device is on another host. Skipping status check."
fi

#echo "Finished supervising garden device."