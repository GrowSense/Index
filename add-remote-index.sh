REMOTE_NAME=$1
REMOTE_HOST=$2
REMOTE_USERNAME=$3
REMOTE_PASSWORD=$4
REMOTE_PORT=$5

EXAMPLE_COMMAND="Example:\n...sh [Name] [Host] [Username] [Password]"

if [ ! $REMOTE_NAME ]; then
  echo "Please provide a name for the remote index as an argument."
  echo $EXAMPLE_COMMAND
  exit 1
fi

if [ ! $REMOTE_HOST ]; then
  echo "Please provide the remote index host path as an argument."
  echo $EXAMPLE_COMMAND
  exit 1
fi

if [ ! $REMOTE_USERNAME ]; then
  echo "Please provide an SSH username for the remote host."
  echo $EXAMPLE_COMMAND
  exit 1
fi

if [ ! $REMOTE_PASSWORD ]; then
  echo "Please provide an SSH password for the remote host."
  echo $EXAMPLE_COMMAND
  exit 1
fi

if [ ! $REMOTE_PORT ]; then
  REMOTE_PORT="22"
fi

echo ""
echo "Adding remote index/computer..."

echo "  Name: $REMOTE_NAME"
echo "  Host: $REMOTE_HOST"
echo "  Username: $REMOTE_USERNAME"
echo "  Password: [hidden]"
echo "  Port: $REMOTE_PORT"

mkdir -p "remote"

if [ ! -f "is-mock-remotes.txt" ]; then
  bash validate-remote-index.sh "add" "$REMOTE_NAME" "$REMOTE_HOST" "$REMOTE_USERNAME" "$REMOTE_PASSWORD" "$REMOTE_PORT" || exit 1
else
  echo "[mock] bash validate-remote-index.sh add $REMOTE_NAME $REMOTE_HOST $REMOTE_USERNAME $REMOTE_PASSWORD $REMOTE_PORT"
fi

REMOTE_INFO_PATH="remote/$REMOTE_NAME"

mkdir -p $REMOTE_INFO_PATH

echo $REMOTE_NAME > $REMOTE_INFO_PATH/name.security
echo $REMOTE_HOST > $REMOTE_INFO_PATH/host.security
echo $REMOTE_USERNAME > $REMOTE_INFO_PATH/username.security
echo $REMOTE_PASSWORD > $REMOTE_INFO_PATH/password.security
echo $REMOTE_PORT > $REMOTE_INFO_PATH/port.security

echo ""
echo "Checking remote computer info files were created..."
[[ ! -f $REMOTE_INFO_PATH/name.security ]] && echo "Remote name.security file wasn't created." && exit 1
[[ ! -f $REMOTE_INFO_PATH/host.security ]] && echo "Remote host.security file wasn't created." && exit 1
[[ ! -f $REMOTE_INFO_PATH/username.security ]] && echo "Remote username.security file wasn't created." && exit 1
[[ ! -f $REMOTE_INFO_PATH/password.security ]] && echo "Remote password.security file wasn't created." && exit 1
[[ ! -f $REMOTE_INFO_PATH/port.security ]] && echo "Remote port.security file wasn't created." && exit 1

echo ""
echo "Pulling device info from remote..."
if [ ! -f "is-mock-remotes.txt" ]; then
  bash pull-device-info-from-remote.sh "$REMOTE_NAME"
else
  echo "[mock] bash pull-device-info-from-remote.sh $REMOTE_NAME"
fi

echo "Finished creating remote index '$REMOTE_NAME'."
echo ""
