echo "Pulling device info from remote garden computer..."

USERNAME=$1
HOST=$2
INDEX_PATH=$3

EXAMPLE_TEXT="Syntax:\nsh pull-device-info.sh [Username] [Host] [IndexPath]\nExample:\nsh pull-device-info.sh j 10.0.0.81 ~/workspace/GreenSense/Index"

if [ ! $USERNAME ]; then
  echo "Username not provided as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $HOST ]; then
  echo "Host not provided as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

if [ ! $INDEX_PATH ]; then
  echo "Index path not provided as an argument."
  echo $EXAMPLE_TEXT
  exit 1
fi

echo "Username: $USERNAME"
echo "Host: $HOST"
echo "Index path: $INDEX_PATH"

scp -r $USERNAME@$HOST:$INDEX_PATH/devices/* devices
