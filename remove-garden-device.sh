echo "Removing device info..."

DEVICE_NAME=$1

if [ ! "$DEVICE_NAME" ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

echo "  Device name: $DEVICE_NAME"

CURRENT_HOST=$(cat /etc/hostname)

if [ -d devices/ ]; then

  if [ ! -d "devices/$DEVICE_NAME" ]; then
    echo "  Error: Device not found."
    exit 1
  else
    DEVICE_HOST="$(cat devices/$DEVICE_NAME/host.txt)"

    if [ "$DEVICE_HOST" == "$CURRENT_HOST" ]; then
      bash remove-garden-device-services.sh $DEVICE_NAME || exit 1
    else
      REMOTE_NAME=""

      for d in remote/*; do
          FOUND_HOST="$(cat $d/host.security)"
          #echo "Host: $FOUND_HOST"

          if [ "$FOUND_HOST" = "$DEVICE_HOST" ]; then
            REMOTE_NAME="$(cat $d/name.security)"
            echo "  Remote name: $REMOTE_NAME"
          fi
      done


      if [ "$REMOTE_NAME" != "" ]; then
        echo "" 
        echo "Removing device from remote..."
        echo ""

        bash run-on-remote.sh $REMOTE_NAME "bash remove-garden-device.sh $DEVICE_NAME" || exit 1
          
        echo ""
        echo "Finished removing device from remote."
        echo ""
      fi
    fi

    echo "" 
    echo "Removing device from local..."
    echo ""

    rm devices/$DEVICE_NAME -r || exit 1
          
    echo ""
    echo "Finished removing device from local."
    echo ""

  fi
fi
echo "Finished removing device info."