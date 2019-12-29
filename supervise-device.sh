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

if [ ! -d "devices/$DEVICE_NAME" ]; then
  echo "  Error: Device $DEVICE_NAME not found."
  exit 1
fi

CURRENT_HOST=$(cat "/etc/hostname")
DEVICE_HOST=$(cat "devices/$DEVICE_NAME/host.txt")
DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")

if [ "$DEVICE_HOST" = "$CURRENT_HOST" ]; then
    bash supervise-device-service.sh $DEVICE_NAME || echo "  Error: Failed to supervise device service"

    STATUS_CHECK_FREQUENCY=$(cat supervisor-status-check-frequency.txt)

    # Skip the first loop (number 0)
    if [ "$LOOP_NUMBER" != "0" ] && [ "$(( $LOOP_NUMBER%$STATUS_CHECK_FREQUENCY ))" -eq "0" ]; then

        bash supervise-device-status.sh $DEVICE_NAME || echo "  Error: Failed to supervise device status"

        if [ -f "supervise-$DEVICE_GROUP-device-status.sh" ]; then
	  bash supervise-$DEVICE_GROUP-device-status.sh $DEVICE_NAME || echo "  Error: Failed to supervise $DEVICE_GROUP device status"
        fi
    fi
else
    echo "  Device is on another host. Skipping status check."
fi

#echo "Finished supervising garden device."