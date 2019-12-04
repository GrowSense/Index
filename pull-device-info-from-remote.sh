REMOTE_NAME=$1

EXAMPLE_COMMAND="Example:\n...sh [Name]"

echo "Pulling device info from remote..."

if [ ! $REMOTE_NAME ]; then
  echo "Please provide a name for the remote index as an argument."
  echo $EXAMPLE_COMMAND
  exit 1
fi

if [ ! -d "remote/$REMOTE_NAME" ]; then
  echo "Remote '$REMOTE_NAME' not found."
  exit 1
fi

REMOTE_HOST=$(cat "remote/$REMOTE_NAME/host.security")
REMOTE_USERNAME=$(cat "remote/$REMOTE_NAME/username.security")
REMOTE_PASSWORD=$(cat "remote/$REMOTE_NAME/password.security")
REMOTE_PORT=$(cat "remote/$REMOTE_NAME/port.security")


echo "  Name: $REMOTE_NAME"
echo "  Host: $REMOTE_HOST"
echo "  Username: $REMOTE_USERNAME"
echo "  Password: [hidden]"
echo "  Port: $REMOTE_PORT"


if sshpass -p $REMOTE_PASSWORD ssh -o "StrictHostKeyChecking no" $REMOTE_USERNAME@$REMOTE_HOST '[[ -d /usr/local/GrowSense/Index/devices ]]'; then
  timeout 2m rsync -rzq -e "sshpass -p $REMOTE_PASSWORD ssh -o StrictHostKeyChecking=no -p $REMOTE_PORT" --progress $REMOTE_USERNAME@$REMOTE_HOST:/usr/local/GrowSense/Index/devices/ devices.tmp/ || exit 1
else
  echo "  Remote /devices/ directory not found. Skipping pull."
fi

DEVICE_WAS_REMOVED=0

if [ -d "devices" ]; then
  echo ""
  echo "  Removing device info for remote devices which have been removed..."
  CURRENT_HOST=$(cat /etc/hostname)

  # Loop through all the devices in the devices directory
  for DEVICE_DIR in devices/*; do

    if [ -d $DEVICE_DIR ]; then

      DEVICE_NAME="$(basename $DEVICE_DIR)"
      #echo "  Device name: $DEVICE_NAME"
      DEVICE_HOST=$(cat "$DEVICE_DIR/host.txt")
        
      # If the device host matches the remote host
      if [ "$DEVICE_HOST" = "$REMOTE_HOST" ]; then

        TMP_DEVICE_DIR="devices.tmp/$DEVICE_NAME"
        #echo "    Tmp device dir: $TMP_DEVICE_DIR"

        # TODO: Remove if not needed. Should be obsolete. Linear MQTT dashboard app is being phased out.
        # Remove the is-ui-created.txt flag so the UI can be recreated locally by the supervisor scripts
        #rm $TMP_DEVICE_DIR/is-ui-created.txt || echo "Failed to remove the is-ui-created.txt flag file"

        # If the device isn't found in the devices tmp directory
        if [ ! -d "$TMP_DEVICE_DIR" ]; then

          echo "    $DEVICE_NAME ($DEVICE_HOST)"
          # Remove the device info because it's been removed from the remote host
          rm -r $DEVICE_DIR || exit 1
          DEVICE_WAS_REMOVED=1

        fi
      fi
    fi
  done
else
  mkdir -p devices
fi

echo ""
echo "  Devices pulled..."
if [ -d "devices.tmp" ]; then
  for DEVICE_DIR in devices.tmp/*; do
    if [ -d $DEVICE_DIR ]; then
      DEVICE_NAME="$(basename $DEVICE_DIR)"
      echo "    $DEVICE_NAME"
    fi
  done

  echo ""
  echo "  Copying device info from devices.tmp/ to devices/..."
  if [ "$(ls -A devices.tmp)" ]; then
    cp devices.tmp/* devices/ -fr || exit 1
  fi

  echo ""
  echo "  Removing devices.tmp/ folder..."
  rm devices.tmp -r || exit 1
else
  echo "    No devices"
fi

#if [ "$DEVICE_WAS_REMOVED" = "1" ]; then
#  echo ""
#  echo "  Recreating Linear MQTT Dashboard UI configuration..."
#  sh recreate-garden-ui.sh
#fi

echo "Finished pull device info from remote"
