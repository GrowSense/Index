echo "Removing message..."

MESSAGE_ID=$1

if [ ! "$MESSAGE_ID" ]; then
  echo "Please provide a message ID as an argument."
  exit 1
fi

echo "  Message ID: $MESSAGE_ID"

if [ -d msgs/ ]; then

  echo ""
  echo "  Finding messages..."

  find msgs/ -name "*$MESSAGE_ID*.txt"|while read FILE_NAME; do

    echo "    $FILE_NAME"

    FOLDER_NAME=$(basename $(dirname $FILE_NAME))

    if [ "$FOLDER_NAME" != "msgs" ]; then

      REMOTE_NAME=$FOLDER_NAME

      echo "    Remote name: $REMOTE_NAME"
      echo ""

      echo "    Removing from remote computer..."
      echo ""

      bash run-on-remote.sh $REMOTE_NAME "bash remove-message.sh $MESSAGE_ID"

      echo ""
      echo "    Finished removing message from remote computer."
      echo ""

    else
      echo "Is local message"	
    fi

    echo "    Removing from local computer..."
    rm  $FILE_NAME
    echo "    Finished removing message from local computer."
    echo ""

  done
else
  echo "The msgs/ directory wasn't found."
  exit 1
fi

echo "$DEVICE_LABEL" > "devices/$DEVICE_NAME/label.txt"

echo "Finished setting device label."