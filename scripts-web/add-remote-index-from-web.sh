echo "Adding remote GrowSense index/computer (from web script)..."

BRANCH=$1
INSTALL_DIR=$2

REMOTE_NAME=$3
REMOTE_HOST=$4
REMOTE_USERNAME=$5
REMOTE_PASSWORD=$6
REMOTE_PORT=$7

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

if [ ! $REMOTE_PORT ]; then
  REMOTE_PORT=22
fi

echo "  Branch: $BRANCH"
echo "  Install dir: $INSTALL_DIR"

echo "  Name: $REMOTE_NAME"
echo "  Host: $REMOTE_HOST"
echo "  Username: $REMOTE_USERNAME"
echo "  Password: [hidden]"
echo "  Port: $REMOTE_PORT"

INDEX_DIR="$INSTALL_DIR"

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  else
    echo "  Is mock sudo"
  fi
fi

echo "  Installing sshpass..."
if ! type "sshpass" &>/dev/null; then
  $SUDO apt-get -y -q install sshpass
fi

echo "  Making the GrowSense index dir (if needed)..."
mkdir -p $INDEX_DIR

echo "  Moving to GrowSense index dir..."
echo "    $INDEX_DIR"
cd $INDEX_DIR

echo "  Downloading validate-remote-index.sh script (if needed)..."
if [ ! -f "validate-remote-index.sh" ]; then
  wget --no-cache https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/validate-remote-index.sh
fi

echo "  Downloading add-remote-index.sh script (if needed)..."
if [ ! -f "add-remote-index.sh" ]; then
  wget --no-cache https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/add-remote-index.sh
fi

echo "  Downloading pull-device-info-from-remote.sh script (if needed)..."
if [ ! -f "pull-device-info-from-remote.sh" ]; then
  wget --no-cache https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/pull-device-info-from-remote.sh
fi


echo "  Adding remote index..."
bash add-remote-index.sh "$REMOTE_NAME" "$REMOTE_HOST" "$REMOTE_USERNAME" "$REMOTE_PASSWORD" "$REMOTE_PORT" || exit 1

echo "Finished adding remote index/computer (from web script)."
echo
