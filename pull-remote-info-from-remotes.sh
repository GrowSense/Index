echo "Pulling remote info from remote indexes..."

if [ -d "remote" ]; then
  echo ""
  echo "  Pulling remote info..."
  for REMOTE_DIR in remote/*; do
    if [ -d $REMOTE_DIR ]; then
      REMOTE_NAME=$(cat "$REMOTE_DIR/name.security")
    
      echo "    Remote name: $REMOTE_NAME"

      sh pull-remote-info-from-remote.sh $REMOTE_NAME
      echo ""
    fi
  done
fi

echo "Finished pulling remote info from remote indexes."
