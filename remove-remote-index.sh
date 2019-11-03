echo "Removing remote index..."

REMOTE_NAME=$1

if [ ! "$REMOTE_NAME" ]; then
  echo "Please provide the remote computer name as an argument..."
  exit 1
fi

if [ ! -d "remote/$REMOTE_NAME" ]; then
  echo "The remote computer name '$REMOTE_NAME' wasn't found."
  exit 1
fi

rm "remote/$REMOTE_NAME" -r

echo "Finished removing remote index."