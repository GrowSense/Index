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

if [ "$DEVICE_GROUP" == "ui" ]; then
  SERVICE_NAME="growsense-ui-1602-$DEVICE_NAME.service"
  SERVICE_STATUS=$(bash systemctl.sh status $SERVICE_NAME)
  SERVICE_LABEL="UI controller"
elif [ "$DEVICE_BOARD" != "esp" ]; then
  SERVICE_NAME="growsense-mqtt-bridge-$DEVICE_NAME.service"
  SERVICE_STATUS=$(bash systemctl.sh status $SERVICE_NAME)
  SERVICE_LABEL="MQTT bridge"
fi

HOST=$(cat /etc/hostname)

if [[ "$SERVICE_NAME" != "" ]]; then
  if [[ $(echo $SERVICE_STATUS) =~ "Reason: No such file or directory" ]]; then
    echo "The service 'SERVICE_NAME' doesn't exist."
    bash send-email.sh "Error: $SERVICE_LABEL service for $DEVICE_NAME hasn't been installed on $HOST." "The $SERVICE_LABEL service for $DEVICE_NAME hasn't been installed on $HOST.  Installing service...\n\nDetails:\n\n$SERVICE_STATUS"

    bash mqtt-publish.sh "garden/StatusMessage" "$DEVICE_NAME offline" -r
  
    bash create-alert-file.sh "The $SERVICE_LABEL service hasn't been installed on $HOST. Installing service..."

    bash create-garden-device-services.sh $DEVICE_NAME
  elif [[ "$SERVICE_RESULT" != *"D;"* ]]; then
 
    echo "The service 'SERVICE_NAME' isn't receiving data from device. Restarting..."
    bash send-email.sh "Error: The $SERVICE_LABEL service isn't receiving data from device $DEVICE_NAME (on $HOST)" "The $SERVICE_LABEL service isn't receiving data from $DEVICE_NAME device on $HOST.  Restarting service...\n\nDetails:\n\n$SERVICE_STATUS"

    bash mqtt-publish.sh "garden/StatusMessage" "$DEVICE_NAME offline" -r

    bash create-alert-file.sh "The $SERVICE_LABEL service isn't receiving data from  $DEVICE_NAME on $HOST. Restarting service..."

    bash systemctl.sh start $SERVICE_NAME
  elif [[ $(echo $SERVICE_RESULT) =~ "Active: inactive" ]] ||  [[ $(echo $SERVICE_RESULT) =~ "Active: dead" ]] ||  [[ $(echo $SERVICE_RESULT) =~ "Active: failed" ]]; then
 
    echo "The service 'SERVICE_NAME' isn't active. Restarting..."
    bash send-email.sh "Error: The $SERVICE_LABEL service for $DEVICE_NAME isn't active on $HOST. Restarting service..." "The $SERVICE_LABEL service for $DEVICE_NAME isn't running on $HOST.  Restarting service...\n\nDetails:\n\n$SERVICE_STATUS"

    bash mqtt-publish.sh "garden/StatusMessage" "$DEVICE_NAME offline" -r

    bash create-alert-file.sh "The $SERVICE_LABEL service for $DEVICE_NAME service isn't active on $HOST. Restarting service..."

    bash systemctl.sh start $SERVICE_NAME
  else
    echo "The service for '$DEVICE_NAME' is active."
  fi
else
  echo "The device '$DEVICE_NAME' has no services. Skipping check."
fi