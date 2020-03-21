DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "  Error: Please provide a device name as an argument."
  exit 1
fi

if [ ! -d "devices/$DEVICE_NAME" ]; then
  echo "  Error: Device not found '$DEVICE_NAME'."
  exit 1
fi

DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")
DEVICE_BOARD=$(cat "devices/$DEVICE_NAME/board.txt")

DEVICE_IS_USB_CONNECTED=$(cat "devices/$DEVICE_NAME/is-usb-connected.txt")

if [ "$DEVICE_BOARD" != "esp" ] && [ "$DEVICE_IS_USB_CONNECTED" == "0" ]; then
  echo "  Device has been disconnected from USB. Skipping status check."

  bash mqtt-publish-device.sh "$DEVICE_NAME" "StatusMessage" "Disconnected" -r

  exit 0
fi

if [ "$DEVICE_GROUP" == "ui" ]; then
  SERVICE_NAME="growsense-ui-1602-$DEVICE_NAME.service"
  SERVICE_RESULT=$(bash systemctl.sh status $SERVICE_NAME)
  SERVICE_LABEL="UI controller"
elif [ "$DEVICE_BOARD" != "esp" ]; then
  SERVICE_NAME="growsense-mqtt-bridge-$DEVICE_NAME.service"
  SERVICE_RESULT=$(bash systemctl.sh status $SERVICE_NAME)
  SERVICE_LABEL="MQTT bridge"
fi

HOST=$(cat /etc/hostname)

if [[ "$SERVICE_NAME" != "" ]]; then
  WAS_SERVICE_OFFLINE=0
  if [ -f "devices/$DEVICE_NAME/is-service-offline.txt" ]; then
    WAS_SERVICE_OFFLINE=$(cat devices/$DEVICE_NAME/is-service-offline.txt)
  fi

  if [[ $(echo $SERVICE_RESULT) =~ "Reason: No such file or directory" ]] || [[ $(echo $SERVICE_RESULT) =~ "could not be found" ]]; then
    echo "The service '$SERVICE_NAME' doesn't exist."

    if [[ "$WAS_SERVICE_OFFLINE" == "0" ]]; then
      echo "  The service was previously online. Sending reports that it's offline..."

      bash send-email.sh "Error: $SERVICE_LABEL service for $DEVICE_NAME hasn't been installed on $HOST." "The $SERVICE_LABEL service for $DEVICE_NAME hasn't been installed on $HOST.  Installing service...\n\nDetails:\n\n$SERVICE_RESULT"

      bash mqtt-publish-device.sh $DEVICE_NAME "StatusMessage" "Offline" -r

      bash create-alert-file.sh "The $SERVICE_LABEL service hasn't been installed on $HOST. Installing service..."

      echo "1" > "devices/$DEVICE_NAME/is-service-offline.txt"
    else
      echo "  The service was previously offline. Reports have already been sent. Skipping send reports..."
    fi

    bash create-garden-device-services.sh $DEVICE_NAME
  elif [[ $(echo $SERVICE_RESULT) =~ "Active: inactive" ]] ||  [[ $(echo $SERVICE_RESULT) =~ "Active: dead" ]] ||  [[ $(echo $SERVICE_RESULT) =~ "Active: failed" ]]; then
    echo "The service 'SERVICE_NAME' isn't active. Restarting..."

    if [[ "$WAS_SERVICE_OFFLINE" == "0" ]]; then
      echo "  The service was previously online. Sending reports that it's offline..."

      bash send-email.sh "Error: The $SERVICE_LABEL service for $DEVICE_NAME isn't active on $HOST. Restarting service..." "The $SERVICE_LABEL service for $DEVICE_NAME isn't running on $HOST.  Restarting service...\n\nDetails:\n\n$SERVICE_RESULT"

      bash mqtt-publish-device.sh $DEVICE_NAME "StatusMessage" "Offline" -r

      bash create-alert-file.sh "The $SERVICE_LABEL service for $DEVICE_NAME service isn't active on $HOST. Restarting service..."

      echo "1" > "devices/$DEVICE_NAME/is-service-offline.txt"
    else
      echo "  The service was previously offline. Reports have already been sent. Skipping send reports..."
    fi

    bash systemctl.sh start $SERVICE_NAME
  elif [[ $(echo $SERVICE_RESULT) =~ "Warning: Journal has been rotated since unit was started. Log output is incomplete or unavailable" ]]; then
    echo "The service 'SERVICE_NAME' log needs to be rotated. Restarting..."

    bash systemctl.sh restart $SERVICE_NAME
  elif [[ $(echo $SERVICE_RESULT) =~ "The unit file, source configuration file or drop-ins of growsense-ui-1602-ui2.service changed on disk" ]]; then
    echo "The service 'SERVICE_NAME' file has changed on disk. Reloading systemctl daemon..."

    bash systemctl.sh daemon-reload
  elif [[ "$SERVICE_RESULT" != *"D;"* ]]; then
     echo "The service '$SERVICE_NAME' isn't receiving data from device. Restarting..."

    if [[ "$WAS_SERVICE_OFFLINE" == "0" ]]; then
      echo "  The service was previously online. Sending reports that it's offline..."
      bash send-email.sh "Error: The $SERVICE_LABEL service isn't receiving data from device $DEVICE_NAME (on $HOST)" "The $SERVICE_LABEL service isn't receiving data from $DEVICE_NAME device on $HOST.  Restarting service...\n\nDetails:\n\n$SERVICE_RESULT"

      bash mqtt-publish-device.sh $DEVICE_NAME "StatusMessage" "Offline" -r

      bash create-alert-file.sh "The $SERVICE_LABEL service isn't receiving data from $DEVICE_NAME on $HOST. Restarting service..."

      echo "1" > "devices/$DEVICE_NAME/is-service-offline.txt"
    else
      echo "  The service was previously offline. Reports have already been sent. Skipping send reports..."
    fi

    bash systemctl.sh start $SERVICE_NAME
  else
    echo "The service for '$DEVICE_NAME' is active."

    if [[ "$WAS_SERVICE_OFFLINE" == "1" ]]; then
      echo "  The service was previously offline. Sending reports that it's back online..."

      bash send-email.sh "The $SERVICE_LABEL service is back online for $DEVICE_NAME (on $HOST)" "The $SERVICE_LABEL service is back online for $DEVICE_NAME device on $HOST.\n\nDetails:\n\n$SERVICE_RESULT"

# TODO: Remove if not needed. The MQTT status checks will check if the device is indeed online.
#      bash mqtt-publish-device.sh $DEVICE_NAME "StatusMessage" "Online" -r

      bash create-message-file.sh "The $SERVICE_LABEL service is back online for $DEVICE_NAME on $HOST."
    else
      echo "  The service was previously online. No need to send reports that it's online."
    fi

    echo "0" > "devices/$DEVICE_NAME/is-service-offline.txt"
  fi
else
  echo "The device '$DEVICE_NAME' has no services. Skipping check."
fi
