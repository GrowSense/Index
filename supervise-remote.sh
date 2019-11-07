REMOTE_NAME=$1

if [ ! "$REMOTE_NAME" ]; then
  echo "Please provide the name of the remote as an argument."
  exit 1
fi

echo "Supervising remote: $REMOTE_NAME"

if [ ! -d "remote/$REMOTE_NAME" ]; then
  echo "  Remote '$REMOTE_NAME' not found."
  exit 1
fi

IS_OFFLINE="0"

CURRENT_HOST=$(cat /etc/hostname)

REMOTE_HOST=$(cat remote/$REMOTE_NAME/host.security)
echo "  Remote name: $REMOTE_NAME"
echo "  Remote host: $REMOTE_HOST"

echo ""
echo "  Pinging remote host..."

PING_RESULT=$(timeout 2 ping $REMOTE_HOST)

echo ""
echo "  Ping result..."
echo "${PING_RESULT}"
echo ""

if [[ "$PING_RESULT" == *"64 bytes from"* ]]; then
  echo "  Ping successful"
else
  echo "  Ping failed"

  bash send-email.sh "Remote '$REMOTE_HOST' cannot be pinged from '$CURRENT_HOST'." "Ping failed to remote '$REMOTE_NAME' with host '$REMOTE_HOST' from '$CURRENT_HOST'.\n\nPing result:\n\n${PING_RESULT}"

  bash publish-mqtt.sh "garden/StatusMessage" "$REMOTE_HOST offline"

  bash create-alert-file.sh "Remote '$REMOTE_NAME' with host '$REMOTE_HOST' if offline or unreachable."

  IS_OFFLINE="1"
fi

REMOTE_COMMAND_RESULT=$(bash run-on-remote.sh $REMOTE_NAME echo "Connection successful")

echo ""
echo "  Remote command result..."
echo "${REMOTE_COMMAND_RESULT}"
echo ""

if [[ "$REMOTE_COMMAND_RESULT" == *"Connection successful"* ]]; then
  echo "  Remote command successful"
else
  echo "  Remote command failed"

  bash send-email.sh "Error: Failed to connect to remote '$REMOTE_HOST' from '$CURRENT_HOST'." "Failed to connect to remote '$REMOTE_NAME' with host '$REMOTE_HOST' from '$CURRENT_HOST' and execute command.\n\nRemote command result:\n\n${REMOTE_COMMAND_RESULT}"

  bash publish-mqtt.sh "garden/StatusMessage" "$REMOTE_HOST offline"

  bash create-alert-file.sh "Remote '$REMOTE_NAME' with host '$REMOTE_HOST' if offline or unreachable."

  IS_OFFLINE="1"
fi

echo "$IS_OFFLINE" > "remote/$REMOTE_NAME/is-offline.txt"

echo "Finished supervising remote: $REMOTE_NAME"