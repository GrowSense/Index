REMOTE_NAME=$1

EXAMPLE_COMMAND="Example:\n...sh [Name]"

echo "Pulling remote info from remote..."

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


if sshpass -p $REMOTE_PASSWORD ssh -o "StrictHostKeyChecking no" $REMOTE_USERNAME@$REMOTE_HOST '[[ -d /usr/local/GrowSense/Index/remote ]]'; then
  timeout 2m rsync -rzq -e "sshpass -p $REMOTE_PASSWORD ssh -o StrictHostKeyChecking=no -p $REMOTE_PORT" --progress $REMOTE_USERNAME@$REMOTE_HOST:/usr/local/GrowSense/Index/remote/ remote.tmp/ || exit 1
else
  echo "  Remote /remote/ directory not found. Skipping pull."
fi

#DEVICE_WAS_REMOVED=0

#if [ -d "remotes" ]; then
#  echo ""
#  echo "  Removing remote info for remote remotes which have been removed..."
#  CURRENT_HOST=$(cat /etc/hostname)

  # Loop through all the remotes in the remotes directory
#  for DEVICE_DIR in remote/*; do

#    if [ -d $DEVICE_DIR ]; then

#      DEVICE_NAME="$(basename $DEVICE_DIR)"
      #echo "  Device name: $DEVICE_NAME"
#      DEVICE_HOST=$(cat "$DEVICE_DIR/host.txt")
        
      # If the remote host matches the remote host
#      if [ "$DEVICE_HOST" = "$REMOTE_HOST" ]; then

#        TMP_DEVICE_DIR="remote.tmp/$DEVICE_NAME"
        #echo "    Tmp remote dir: $TMP_DEVICE_DIR"

        # TODO: Remove if not needed. Should be obsolete. Linear MQTT dashboard app is being phased out.
        # Remove the is-ui-created.txt flag so the UI can be recreated locally by the supervisor scripts
        #rm $TMP_DEVICE_DIR/is-ui-created.txt || echo "Failed to remove the is-ui-created.txt flag file"

        # If the remote isn't found in the remotes tmp directory
#        if [ ! -d "$TMP_DEVICE_DIR" ]; then

#          echo "    $DEVICE_NAME ($DEVICE_HOST)"
          # Remove the remote info because it's been removed from the remote host
#          rm -r $DEVICE_DIR || exit 1
#          DEVICE_WAS_REMOVED=1

#        fi
#      fi
#    fi
#  done
#else
#  mkdir -p remotes
#fi

#echo ""
echo "  Remotes pulled..."
if [ -d "remote.tmp" ]; then
  for DEVICE_DIR in remote.tmp/*; do
    if [ -d $DEVICE_DIR ]; then
      DEVICE_NAME="$(basename $DEVICE_DIR)"
      echo "    $DEVICE_NAME"
    fi
  done

  echo ""
  echo "  Copying remote info from remote.tmp/ to remote/..."
  if [ "$(ls -A remote.tmp)" ]; then
    cp remote.tmp/* remote/ -fr || exit 1
  fi

  echo ""
  echo "  Removing remote.tmp/ folder..."
  rm remote.tmp -r || exit 1
else
  echo "    No remotes"
fi

echo "Finished pull remote info from remote"
