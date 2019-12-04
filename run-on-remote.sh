echo "Running command on remote computer..."

REMOTE_NAME=$1

if [ ! "$REMOTE_NAME" ]; then
  echo "Please specify the remote computer name as an argument..."
  exit 1
fi

echo "  Name: $REMOTE_NAME"

if [ ! -d "remote/$REMOTE_NAME" ]; then
  echo "The specifed remote computer '$REMOTE_NAME' wasn't found."
  exit 1
fi

REMOTE_HOST="$(cat remote/$REMOTE_NAME/host.security)"
REMOTE_USERNAME="$(cat remote/$REMOTE_NAME/username.security)"
REMOTE_PASSWORD="$(cat remote/$REMOTE_NAME/password.security)"
REMOTE_PORT="$(cat remote/$REMOTE_NAME/port.security)"

echo "  Host: $REMOTE_HOST"
echo "  Username: $REMOTE_USERNAME"
echo "  Password: [hidden]"
echo "  Port: $REMOTE_PORT"

echo ""
echo "  Command: $2 $3 $4 $5 $6 $7 $8 $9"
echo ""

echo ""
echo "  Launching command on remote computer..."
sshpass -p $REMOTE_PASSWORD ssh -o "StrictHostKeyChecking no" -p $REMOTE_PORT $REMOTE_USERNAME@$REMOTE_HOST "cd /usr/local/GrowSense/Index && $2 $3 $4 $5 $6 $7 $8 $9" || exit 1

echo "Finished running command on remote computer."