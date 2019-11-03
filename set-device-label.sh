echo "Setting device label..."

DEVICE_NAME=$1
DEVICE_LABEL=$2

if [ ! "$DEVICE_NAME" ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

if [ ! "$DEVICE_LABEL" ]; then
  echo "Please provide a device label as an argument."
  exit 1
fi

echo "  Device name: $DEVICE_NAME"
echo "  Device label: $DEVICE_LABEL"

CURRENT_HOST="$(cat /etc/hostname)"

DEVICE_HOST="$(cat devices/$DEVICE_NAME/host.txt)"

echo "  Device host: $DEVICE_HOST"

if [ "$DEVICE_HOST" != "$CURRENT_HOST" ]; then

  REMOTE_NAME=""

   echo "    Identifying remote host name..."
   for d in remote/*; do
      NAME=$(cat $d/name.security)      
      HOST=$(cat $d/host.security)      

      if [ "$DEVICE_HOST" = "$HOST" ]; then
        REMOTE_NAME="$NAME"
        echo "      Remote name: $REMOTE_NAME"
      fi  
  done

  REMOTE_USERNAME="$(cat remote/$REMOTE_NAME/username.security)"
  REMOTE_PASSWORD="$(cat remote/$REMOTE_NAME/password.security)"
  REMOTE_PORT="$(cat remote/$REMOTE_NAME/port.security)"

  echo "    Host: $DEVICE_HOST"
  echo "    Username: $REMOTE_USERNAME"
  echo "    Password: [hidden]"
  echo "    Port: $REMOTE_PORT"

  echo ""
  echo "  Setting device label on remote host..."
  echo ""
  sshpass -p $REMOTE_PASSWORD ssh -o "StrictHostKeyChecking no" -p $REMOTE_PORT $REMOTE_USERNAME@$DEVICE_HOST "cd /usr/local/GrowSense/Index && bash set-device-label.sh $DEVICE_NAME $DEVICE_HOST"

  echo ""
  echo "  Finished setting device label on remote host."
  echo ""
fi

echo "$DEVICE_LABEL" > "devices/$DEVICE_NAME/label.txt"

echo "Finished setting device label."