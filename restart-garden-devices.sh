echo ""
echo "Restarting garden device services..."
echo ""


DEVICES_DIR="devices"

CURRENT_HOST=$(cat /etc/hostname)

if [ -d "$DEVICES_DIR" ]; then
  for d in $DEVICES_DIR/*; do
    if [ -d $d ]; then
      DEVICE_NAME=$(cat $d/name.txt)
      DEVICE_LABEL=$(cat $d/label.txt)
      DEVICE_HOST=$(cat $d/host.txt)

      echo "$DEVICE_LABEL"
      echo "Name: $DEVICE_NAME"
      echo "Host: $DEVICE_HOST"
      echo "Current host: $CURRENT_HOST"

      if [ "$DEVICE_HOST" != "$CURRENT_HOST" ]; then
        echo "  Device is on another host. Skipping restart service..."
      else
        sh restart-garden-device.sh $DEVICE_NAME || exit 1
      fi

      echo ""
    fi
  done
else
    echo "No device info found in $DEVICES_DIR"
fi

echo ""
echo "Finished restarting garden device services"
echo ""
