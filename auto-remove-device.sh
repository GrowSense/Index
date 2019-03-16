BOARD_TYPE=$1
FAMILY_NAME=$2
GROUP_NAME=$3
PROJECT_NAME=$4
PORT=$5

EXAMPLE="Example:\n\t...sh [BoardType] [ProjectFamily] [ProjectGroup] [ProjectName] [Port]"

if [ ! $FAMILY_NAME ]; then
  echo "Provide a family name as an argument."
  echo $EXAMPLE
  exit 1
fi

if [ ! $GROUP_NAME ]; then
  echo "Provide a group name as an argument."
  echo $EXAMPLE
  exit 1
fi
if [ ! $PROJECT_NAME ]; then
  echo "Provide a project name as an argument."
  echo $EXAMPLE
  exit 1
fi
if [ ! $BOARD_TYPE ]; then
  echo "Provide a board type as an argument."
  echo $EXAMPLE
  exit 1
fi
if [ ! $PORT ]; then
  echo "Provide a port as an argument."
  echo $EXAMPLE
  exit 1
fi

echo "Automatically removing device..."

WORKSPACE_DIR="workspace"

mkdir -p $WORKSPACE_DIR

cd $WORKSPACE_DIR

INDEX_DIR="GreenSense/Index"

if [ ! -d $INDEX_DIR ]; then
  echo "GreenSense index not found locally. Setting up."
  wget -O - https://raw.githubusercontent.com/GreenSense/Index/master/setup-from-github.sh | sh
fi

cd $INDEX_DIR

echo $PWD

sh update.sh

DEVICE_NUMBER=1

echo "Device number: $DEVICE_NUMBER"

#DEVICE_INFO_DIR="devices/$GROUP_NAME$DEVICE_NUMBER"

if [ -d "$DEVICE_INFO_DIR" ]; then

  echo "Device exists"
  
  until [ ! -d "$DEVICE_INFO_DIR" ]; do
    echo "Increasing device number"
    DEVICE_NUMBER=$((DEVICE_NUMBER+1))
    DEVICE_INFO_DIR="devices/$GROUP_NAME$DEVICE_NUMBER"
    echo "Device info dir:"
    echo $DEVICE_INFO_DIR
  done
fi

DEVICE_NAME="$GROUP_NAME$DEVICE_NUMBER"
echo "Device name: $DEVICE_NAME"

echo "Device info dir:"
echo $DEVICE_INFO_DIR



SCRIPT_NAME="remove-garden-device.sh"
echo ""
echo "Add device script:"
echo $SCRIPT_NAME "$DEVICE_NAME"
echo ""
sh $SCRIPT_NAME "$DEVICE_NAME"


