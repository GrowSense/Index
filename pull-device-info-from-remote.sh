REMOTE_NAME=$1

EXAMPLE_COMMAND="Example:\n...sh [Name]"

if [ ! $REMOTE_NAME ]; then
  echo "Please provide a name for the remote index as an argument."
  echo $EXAMPLE_COMMAND
  exit 1
fi

if [ ! -d "remote/$REMOTE_NAME" ]; then
  echo "Remote '$REMOTE_NAME' not found."
  exit 1
fi

REMOTE_HOST=$(cat "remote/$REMOTE_NAME/host.txt")
REMOTE_USERNAME=$(cat "remote/$REMOTE_NAME/username.txt")
REMOTE_PASSWORD=$(cat "remote/$REMOTE_NAME/password.txt")


echo "Name: $REMOTE_NAME"
echo "Host: $REMOTE_HOST"
echo "Username: $REMOTE_USERNAME"
echo "Password: [hidden]"

sshpass -p $REMOTE_PASSWORD scp -r $REMOTE_USERNAME@$REMOTE_HOST:/usr/local/GreenSense/Index/devices/* devices/


