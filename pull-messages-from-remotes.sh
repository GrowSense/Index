echo "Pulling messages from remote computers..."

if [ -d "remote" ]; then
  echo ""
  echo "  Pulling messages..."
  for REMOTE_DIR in remote/*; do
    REMOTE_NAME=$(cat "$REMOTE_DIR/name.security")
    
    echo "    Remote name: $REMOTE_NAME"

    sh pull-messages-from-remote.sh $REMOTE_NAME
    echo ""
  done
fi

echo "Finished pulling messages from remote computers."
