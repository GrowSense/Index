echo "Adding remote GrowSense index..."

BRANCH=$1
INSTALL_DIR=$2

REMOTE_NAME=$3
REMOTE_HOST=$4
REMOTE_USERNAME=$5
REMOTE_PASSWORD=$6

EXAMPLE_COMMAND="Example:\n..sh [Branch] [InstallDir] [RemoteName] [RemoteHost] [RemoteUsername] [RemotePassword]"

if [ ! $BRANCH ]; then
  BRANCH="master"
fi

if [ "$INSTALL_DIR" = "?" ]; then
    INSTALL_DIR="/usr/local/GrowSense/Index"
fi
if [ ! "$INSTALL_DIR" ]; then
    INSTALL_DIR="/usr/local/GrowSense/Index"
fi

if [ ! $REMOTE_NAME ]; then
  echo "Please provide a name for the remote index as an argument."
  echo $EXAMPLE_COMMAND
  exit 1
fi

if [ ! $REMOTE_HOST ]; then
  echo "Please provide the remote index host path as an argument."
  echo $EXAMPLE_COMMAND
  exit 1
fi

if [ ! $REMOTE_USERNAME ]; then
  echo "Please provide an SSH username for the remote host."
  echo $EXAMPLE_COMMAND
  exit 1
fi

if [ ! $REMOTE_PASSWORD ]; then
  echo "Please provide an SSH password for the remote host."
  echo $EXAMPLE_COMMAND
  exit 1
fi

echo "Branch: $BRANCH"
echo "Install dir: $INSTALL_DIR"

echo "Name: $REMOTE_NAME"
echo "Host: $REMOTE_HOST"
echo "Username: $REMOTE_USERNAME"
echo "Password: [hidden]"

INDEX_DIR="$INSTALL_DIR"

echo "Making the GrowSense index dir (if needed)..."
mkdir -p $INDEX_DIR

echo "Moving to GrowSense index dir..."
cd $INDEX_DIR

echo "Adding remote index..."
wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/add-remote-index.sh | bash -s -- $REMOTE_NAME $REMOTE_HOST $REMOTE_USERNAME $REMOTE_PASSWORD

echo "Finished adding remote index"
