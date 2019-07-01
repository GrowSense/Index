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

# rsync is faster
rsync -rzq -e "sshpass -p $REMOTE_PASSWORD ssh -o StrictHostKeyChecking=no -p $REMOTE_PORT" --progress $REMOTE_USERNAME@$REMOTE_HOST:/usr/local/GreenSense/Index/devices/ devices.tmp/ || exit 1

# scp is slower
#sshpass -p $REMOTE_PASSWORD scp -r -o StrictHostKeyChecking=no $REMOTE_USERNAME@$REMOTE_HOST:/usr/local/GreenSense/Index/devices .

if [ -d "devices" ]; then
  echo ""
  echo "  Removing device info for remote devices which have been removed..."
  CURRENT_HOST=$(cat /etc/hostname)
  # Loop through all the devices in the devices directory
  for DEVICE_DIR in devices/*; do
    DEVICE_NAME="$(basename $DEVICE_DIR)"
    #echo "  Device name: $DEVICE_NAME"
    DEVICE_HOST=$(cat "$DEVICE_DIR/host.txt")
    
    # If the device host matches the remote host
    if [ "$DEVICE_HOST" = "$REMOTE_HOST" ]; then
      TMP_DEVICE_DIR="devices.tmp/$DEVICE_NAME"
      #echo "    Tmp device dir: $TMP_DEVICE_DIR"
      # If the device isn't found in the devices tmp directory
      if [ ! -d "$TMP_DEVICE_DIR" ]; then
        echo "    $DEVICE_NAME ($DEVICE_HOST)"
        # Remove the device info because it's been removed from the remote host
        rm -r $DEVICE_DIR || exit 1
      fi
    fi
  done
fi

# Copy all the devices from the tmp dir to the devices dir
cp devices.tmp/* devices/ -fr || exit 1

# Delete the tmp dir
rm devices.tmp -r || exit 1

echo "Finished pull device info from remote"
