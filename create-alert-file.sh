echo "Creating alert file..."

ALERT_TEXT=$1

if [ ! "$ALERT_TEXT" ]; then
  echo "Please provide the alert text as an argument."
  exit 1
fi

MSGS_DIR="msgs"

mkdir -p "$MSGS_DIR"

UNIQUE_ID=$(cat /proc/sys/kernel/random/uuid)

DATE_STRING="$(date '+%Y-%m-%d-%H-%M-%S')"

FILE_PATH="$MSGS_DIR/$DATE_STRING--$UNIQUE_ID.alert.txt"

echo "Alert: $ALERT_TEXT"
echo "File: $FILE_PATH"

echo "$ALERT_TEXT" > "$FILE_PATH"

echo "Finished creating alert file."