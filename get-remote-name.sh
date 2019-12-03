REMOTE_HOST=$1

echo "Getting name of remote host..."

if [ ! $REMOTE_HOST ]; then
  echo "  Error: Please provide the path of remote host."
  exit 1
fi

if [ ! -d remote ]; then
  echo "  Error: No remotes directory found."
  exit 1
fi

echo "  Remote host: $REMOTE_HOST"

REMOTE_NAME=""

for REMOTE_INFO_DIR in remote/*; do
  if [ -d "$REMOTE_INFO_DIR" ]; then
    if [ "$(cat $REMOTE_INFO_DIR/host.security)" == "$REMOTE_HOST" ]; then
      REMOTE_NAME="$(cat $REMOTE_INFO_DIR/name.security)"
    fi
  fi
done

echo "  Remote name: $REMOTE_NAME"

echo "Finished getting name of remote host."
