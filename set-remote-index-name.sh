echo "Setting remote index name..."

ORIGINAL_NAME=$1
NEW_NAME=$2

if [ ! "$ORIGINAL_NAME" ]; then
  echo "Please provide the original name as an argument..."
  exit 1
fi

if [ ! "$NEW_NAME" ]; then
  echo "Please provide the new name as an argument..."
  exit 1
fi

if [ ! -d "remote/$ORIGINAL_NAME" ]; then
  echo "The remote computer name '$ORIGINAL_NAME' wasn't found."
  exit 1
fi

mv "remote/$ORIGINAL_NAME" "remote/$NEW_NAME"

echo "$NEW_NAME" > "remote/$NEW_NAME/name.security"

echo "Finished setting remote index name."