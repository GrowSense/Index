echo "Pulling device info from remote indexes..."

if [ -d "remote" ]; then
  if [ -d "devices" ]; then
    echo "  Removing existing remote devices..."
    CURRENT_HOST=$(cat /etc/hostname)
    for DEVICE_DIR in devices/*; do
      DEVICE_NAME=$(cat "$DEVICE_DIR/name.txt")
      DEVICE_HOST=$(cat "$DEVICE_DIR/host.txt")
      
      if [ "$DEVICE_HOST" != "$CURRENT_HOST" ]; then
        echo "    Device name: $DEVICE_NAME"
        rm -r $DEVICE_DIR
      fi
    done
  fi

  echo ""
  echo "  Pulling device info..."
  for REMOTE_DIR in remote/*; do
    REMOTE_NAME=$(cat "$REMOTE_DIR/name.security")
    
    echo "    Remote name: $REMOTE_NAME"

    sh pull-device-info-from-remote.sh $REMOTE_NAME
  done

  echo ""
  echo "  Recreating Linear MQTT Dashboard UI configuration..."
  sh recreate-garden-ui.sh
fi

echo "Finished pulling device info from remote indexes."
