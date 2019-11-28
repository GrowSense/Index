echo "Creating message file..."

MESSAGE_TEXT=$1

if [ ! "$MESSAGE_TEXT" ]; then
  echo "Please provide the message text as an argument."
  exit 1
fi

MSGS_DIR="msgs"

mkdir -p "$MSGS_DIR"

UNIQUE_ID=$(cat /proc/sys/kernel/random/uuid)

DATE_STRING="$(date '+%Y-%m-%d-%H-%M-%S')"

FILE_PATH="$MSGS_DIR/$DATE_STRING--$UNIQUE_ID.msg.txt"

echo "Message: $MESSAGE_TEXT"
echo "File: $FILE_PATH"

echo "$MESSAGE_TEXT" > "$FILE_PATH" || exit 1

echo "Finished creating message file."