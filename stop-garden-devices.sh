
DEVICES_DIR="devices"

if [ -d "$DEVICES_DIR" ]; then
  for d in $DEVICES_DIR/*; do
    if [ -d "$d" ]; then
      DEVICE_NAME=$(cat $d/name.txt)
      DEVICE_LABEL=$(cat $d/label.txt)        
        
      echo "$DEVICE_LABEL"
        
      sh stop-garden-device.sh $DEVICE_NAME || exit 1
       
      echo ""
    fi
  done
else
  echo "No device info found in $DEVICES_DIR"
fi