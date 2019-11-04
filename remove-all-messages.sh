echo "Removing all messages..."

RECURSIVE=$1


if [ -d "msgs/" ]; then
  if [ "$RECURSIVE" != "false" ]; then
    echo "Checking for remotes..."

    for d in msgs/*; do

      echo ""
      echo "Removing all messages on remote: $REMOTE_NAME"
      echo ""

      sh run-on-remote.sh "$REMOTE_NAME" "bash remove-all-messages.sh false"

      echo ""
      echo "Finished all messages on remote: $REMOTE_NAME"
      echo ""

    done
  fi

  echo "Removing all local messages..."
  rm msgs/ -r

else
  echo "No messages directory found."
fi

echo "Finished removing all messages."