
echo "Cleaning disconnected devices..."

DEVICES_DIR="devices"

if [ -d "$DEVICES_DIR" ]; then
    for d in $DEVICES_DIR/*; do
      echo "$d"
      
      BOARD=$(cat "$d/board.txt")
      DEVICE_NAME=$(cat "$d/name.txt")  
      
      echo "  Checking device: $DEVICE_NAME"
      
      if [ "$BOARD" = "esp" ]; then
        echo "    WiFi board. Leaving installed."
      else    
        echo "    Removing $DEVICE_NAME"
        sh remove-garden-device.sh $DEVICE_NAME
      fi
    done
else
    echo "  No devices have been added."
fi

