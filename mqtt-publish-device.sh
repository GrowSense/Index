DEVICE_NAME=$1
KEY=$2
MESSAGE=$3

EXAMPLE_USAGE="Example:\n...sh [DeviceName] [Key] [Message]"

if [ ! "$DEVICE_NAME" ]; then
  echo "Please provide a device name as an argument."
  echo $EXAMPLE_USAGE
  exit 1
fi

if [ ! "$KEY" ]; then
  echo "Please provide a key as an argument."
  echo $EXAMPLE_USAGE
  exit 1
fi

if [ ! "$MESSAGE" ]; then
  echo "Please provide a message as an argument."
  echo $EXAMPLE_USAGE
  exit 1
fi

sh mqtt-publish.sh "/$DEVICE_NAME/$KEY" "$MESSAGE"
