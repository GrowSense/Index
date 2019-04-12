REMOTE_NAME=$1
REMOTE_HOST=$2
REMOTE_USERNAME=$3
REMOTE_PASSWORD=$4

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

echo "Name: $REMOTE_NAME"
echo "Host: $REMOTE_HOST"
echo "Username: $REMOTE_USERNAME"
echo "Password: [hidden]"

mkdir -p "remote"

REMOTE_INFO_PATH="remote/$REMOTE_NAME"

mkdir -p $REMOTE_INFO_PATH

echo $REMOTE_NAME > $REMOTE_INFO_PATH/name.security
echo $REMOTE_HOST > $REMOTE_INFO_PATH/host.security
echo $REMOTE_USERNAME > $REMOTE_INFO_PATH/username.security
echo $REMOTE_PASSWORD > $REMOTE_INFO_PATH/password.security

echo "Finished creating remote index '$REMOTE_NAME'."
