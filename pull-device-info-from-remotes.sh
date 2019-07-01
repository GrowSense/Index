echo "Pulling device info from remote indexes..."

if [ -d "remote" ]; then
  echo ""
  echo "  Pulling device info..."
  for REMOTE_DIR in remote/*; do
    REMOTE_NAME=$(cat "$REMOTE_DIR/name.security")
    
    echo "    Remote name: $REMOTE_NAME"

    sh pull-device-info-from-remote.sh $REMOTE_NAME
    echo ""
  done

  echo ""
  echo "  Recreating Linear MQTT Dashboard UI configuration..."
  sh recreate-garden-ui.sh
fi

echo "Finished pulling device info from remote indexes."
