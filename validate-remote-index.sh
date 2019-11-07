ACTION=$1
REMOTE_NAME=$2
REMOTE_HOST=$3
REMOTE_USERNAME=$4
REMOTE_PASSWORD=$5
REMOTE_PORT=$6

EXAMPLE_COMMAND="Example:\n...sh [Action] [Name] [Host] [Username] [Password] [Port]"

if [ ! $ACTION ]; then
  echo "Please specify the action being validated."
  echo $EXAMPLE_COMMAND
  exit 1
fi

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
  echo "Please provide an SSH port for the remote host."
  echo $EXAMPLE_COMMAND
  exit 1
fi

echo "Name: $REMOTE_NAME"
echo "Host: $REMOTE_HOST"
echo "Username: $REMOTE_USERNAME"
echo "Password: [hidden]"
echo "Port: $REMOTE_PORT"

echo ""
echo "Checking computer name doesn't already exist..."

if [ "$ACTION" == "add" ]; then
  if [ -d "remote/$REMOTE_NAME" ]; then
    echo "Error: Remote computer name '$REMOTE_NAME' is already in use."
    exit 1
  fi

  echo ""
  echo "Checking computer hasn't already been added by checking the host path..."

  if [ -d "remote" ]; then
      for d in remote/*; do
          LOADED_HOST=$(cat $d/host.security)
          LOADED_NAME=$(cat $d/name.security)

          if [ "$REMOTE_HOST" = "$LOADED_HOST" ]; then
            echo "Error: Remote computer with the path '$LOADED_HOST' has already been added with the name '$LOADED_NAME'."
            exit 1
          fi
      done
  fi
fi

echo ""
echo "Testing ping to the remote computer..."

PING_RESULT="$(timeout 5 ping $REMOTE_HOST)"

if [[ ! $(echo $PING_RESULT) =~ "64 bytes from" ]]; then
  echo "Error: Remote computer '$REMOTE_NAME' at path '$REMOTE_HOST' is offline or cannot be found."
  echo ""
  echo "${PING_RESULT}"
  exit 1
fi

echo ""
echo "Testing connection to the remote computer..."

CONNECTION_RESULT=$(sshpass -p $REMOTE_PASSWORD ssh -o "StrictHostKeyChecking no" -p $REMOTE_PORT $REMOTE_USERNAME@$REMOTE_HOST "echo 'Connection successful'")

if [[ $(echo $CONNECTION_RESULT) =~ "Permission denied" ]]; then
  echo "Error: Connection to remote computer '$REMOTE_NAME' at path '$REMOTE_HOST' failed. Permission denied. Check the username and password."
  echo ""
  echo "${CONNECTION_RESULT}"
  exit 1
elif [[ ! $(echo $CONNECTION_RESULT) =~ "Connection successful" ]]; then
  echo "Error: Connection to remote computer '$REMOTE_NAME' at path '$REMOTE_HOST' failed. Check the username, password and port."
  echo ""
  echo "${CONNECTION_RESULT}"
  exit 1
else
  echo ""
  echo "Connection result:"
  echo "${CONNECTION_RESULT}"
fi

echo "Finished validating remote index '$REMOTE_NAME'."
