#!/bin/bash
echo "Checking whether system is locked..."

IS_LOCKED=0

CURRENT_HOST="$(cat /etc/hostname)"

echo "  Current host: $CURRENT_HOST"
echo ""

for DEVICE_INFO_DIR in devices/*; do
  #echo "$DEVICE_INFO_DIR"
  
  DEVICE_NAME=$(basename "$DEVICE_INFO_DIR")
  
  echo "$DEVICE_NAME"
  
  IS_UPLOADING_FILE=$DEVICE_INFO_DIR/is-uploading.txt
  DEVICE_HOST_FILE=$DEVICE_INFO_DIR/host.txt
  DEVICE_HOST=$(cat $DEVICE_HOST_FILE)
  echo "  Device host: $DEVICE_HOST"
      
  if [ -f $IS_UPLOADING_FILE ]; then
    IS_UPLOADING=$(cat $IS_UPLOADING_FILE)
    echo "  Is uploading: $IS_UPLOADING"

    if [ "$IS_UPLOADING" = "1" ] & [ "$DEVICE_HOST" = "$CURRENT_HOST" ]; then
      echo "  $DEVICE_NAME is uploading"
      IS_LOCKED=1
    fi
  #else
    #echo "  Is uploading: 0"
  fi
done

if [ "$IS_LOCKED" = 1 ]; then
  echo "  System locked"
else
  echo "  System free"
fi

echo "Finished checking whether system is locked"
