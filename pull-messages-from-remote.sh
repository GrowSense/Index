REMOTE_NAME=$1

EXAMPLE_COMMAND="Example:\n...sh [Name]"

echo "Pulling messages from remote..."

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
rsync -rzq -e "sshpass -p $REMOTE_PASSWORD ssh -o StrictHostKeyChecking=no -p $REMOTE_PORT" --progress $REMOTE_USERNAME@$REMOTE_HOST:/usr/local/GrowSense/Index/msgs/ msgs/$REMOTE_NAME/ || exit 1

echo "Finished pull messages from remote"
