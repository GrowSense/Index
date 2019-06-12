DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

CURRENT_HOST=$(cat /etc/hostname)

DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")
DEVICE_HOST=$(cat "devices/$DEVICE_NAME/host.txt")
DEVICE_BOARD=$(cat "devices/$DEVICE_NAME/host.txt")

if [ "$DEVICE_BOARD" != "esp" ]; then
  if [ "$DEVICE_GROUP" = "ui" ]; then
    if [ "$DEVICE_HOST" = "$CURRENT_HOST" ]; then
      OUTPUT=$(sh view-ui-controller-1602-status.sh $DEVICE_NAME)

      RESULT="NotSet"
      SUB_RESULT=""

      case "$OUTPUT" in 
        *inactive*)
          RESULT="Inactive"
          ;;
        *active*)
          RESULT="Active"
          ;;
        *failed*)
          RESULT="Failed"
          ;;
      esac

      # TODO: Reimplement if possible
      #case "$OUTPUT" in 
      #  *MqttConnectionException*)
      #    SUB_RESULT="Failed to connect to broker"
      #    ;;
      #  *"An error occurred while retrieving package metadata"*)
      #    SUB_RESULT="Nuget connection error"
      #    ;;
      #  *"No such file or directory"*)
      #    SUB_RESULT="USB device not found"
      #    ;;
      #esac

      #echo $OUTPUT

      echo "  UI Controller Service: $RESULT"

      if [ "$SUB_RESULT" ]; then
        echo "    $SUB_RESULT"
      fi
    fi
  else
    if [ "$DEVICE_HOST" = "$CURRENT_HOST" ]; then
      OUTPUT=$(sh view-mqtt-bridge-status.sh $DEVICE_NAME)

      RESULT="NotSet"
      SUB_RESULT=""

      case "$OUTPUT" in 
        *inactive*)
          RESULT="Inactive"
          ;;
        *active*)
          RESULT="Active"
          ;;
        *failed*)
          RESULT="Failed"
          ;;
      esac

      case "$OUTPUT" in 
        *MqttConnectionException*)
          SUB_RESULT="Failed to connect to broker"
          ;;
        *"An error occurred while retrieving package metadata"*)
          SUB_RESULT="Nuget connection error"
          ;;
        *"No such file or directory"*)
          SUB_RESULT="USB device not found"
          ;;
      esac

      #echo $OUTPUT

      echo "  MQTT Bridge Service: $RESULT"

      if [ "$SUB_RESULT" ]; then
        echo "    $SUB_RESULT"
      fi
    fi
    
    sh check-garden-device-mqtt.sh $DEVICE_NAME
  fi
else
  sh check-garden-device-mqtt.sh $DEVICE_NAME
fi
