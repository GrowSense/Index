echo "Pulling device info from remote indexes..."

if [ -d "remote" ]; then
  echo ""
  echo "  Pulling device info..."
  for REMOTE_DIR in remote/*; do
    if [ -d $REMOTE_DIR ]; then
      REMOTE_NAME=$(cat "$REMOTE_DIR/name.security")
    
      echo "    Remote name: $REMOTE_NAME"

      sh pull-device-info-from-remote.sh $REMOTE_NAME
      echo ""
    fi
  done

# Disabled because the supervisor script should take care of this
#  echo ""
#  echo "  Recreating Linear MQTT Dashboard UI configuration..."
#  sh recreate-garden-ui.sh
fi

echo "Finished pulling device info from remote indexes."
