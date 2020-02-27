#!/bin/bash
echo "Checking whether system is locked..."

IS_LOCKED=0

CURRENT_HOST="$(cat /etc/hostname)"

echo "  Current host: $CURRENT_HOST"
echo ""

if [ -f "is-upgrading.txt" ]; then
  echo "  System is upgrading..."
  IS_LOCKED=1
fi

if [ "$IS_LOCKED" == "0" ]; then
  if [ -d devices ]; then
	  for DEVICE_INFO_DIR in devices/*; do
	    #echo "$DEVICE_INFO_DIR"

	    DEVICE_NAME=$(basename "$DEVICE_INFO_DIR")

      if [ "$DEVICE_NAME" != "*" ]; then

		    echo "$DEVICE_NAME"

		    IS_UPLOADING_FILE=$DEVICE_INFO_DIR/is-uploading.txt
		    DEVICE_HOST_FILE=$DEVICE_INFO_DIR/host.txt
		    DEVICE_HOST=$(cat $DEVICE_HOST_FILE)
		    echo "  Device host: $DEVICE_HOST"

		    if [ "$DEVICE_HOST" = "$CURRENT_HOST" ]; then
		    	  echo "  Device is on current host"
			    if [ -f $IS_UPLOADING_FILE ]; then
			      IS_UPLOADING="$(cat $IS_UPLOADING_FILE)"
			      echo "  Is uploading: $IS_UPLOADING"

			      if [ "$IS_UPLOADING" = "1" ]; then
			        echo "  $DEVICE_NAME is uploading"
			        IS_LOCKED=1
			      fi
			    #else
			      #echo "  Is uploading: 0"
			    fi
		    else
		        echo "  Device is on another host"
		    fi
      fi
	  done
  fi
fi

if [ "$IS_LOCKED" = "1" ]; then
  echo "  System locked"
else
  echo "  System free"
fi

echo "Finished checking whether system is locked"
