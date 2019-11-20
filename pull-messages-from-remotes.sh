echo "Pulling messages from remote computers..."

if [ -d "remote" ]; then
  echo ""
  echo "  Pulling messages..."
  for REMOTE_DIR in remote/*; do
    if [ -d $REMOTE_DIR ]; then
      REMOTE_NAME=$(cat "$REMOTE_DIR/name.security")
    
      echo "    Remote name: $REMOTE_NAME"

      sh pull-messages-from-remote.sh $REMOTE_NAME
      echo ""
    fi
  done
fi

echo "Finished pulling messages from remote computers."
