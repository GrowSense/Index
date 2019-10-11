echo "Setting WiFi credentials..."

BRANCH=$1
INSTALL_DIR=$2

WIFI_NAME=$3
WIFI_PASSWORD=$4

EXAMPLE_COMMAND="Example:\n..sh master '?' [WiFiName] [WiFiPassword]"

if [ ! $BRANCH ]; then
    echo "Specify branch as an argument."
    echo "$EXAMPLE_COMMAND"
    exit 1
fi

if [ "$INSTALL_DIR" = "?" ]; then
    INSTALL_DIR="/usr/local/GrowSense/Index"
fi


if [ ! $WIFI_NAME ]; then
    echo "Specify WiFi network name as an argument."
    echo "$EXAMPLE_COMMAND"
    exit 1
fi

if [ ! $WIFI_PASSWORD ]; then
    echo "Specify WiFi network password as an argument."
    echo "$EXAMPLE_COMMAND"
    exit 1
fi

echo "Branch: $BRANCH"
echo "Install dir: $INSTALL_DIR"

echo "WiFi Name: $WIFI_NAME"
echo "WiFi Password: [hidden]"

if [ ! -d "$INSTALL_DIR" ]; then
  echo "Creating the install directory..."
  mkdir -p "$INSTALL_DIR" || (echo "Failed to create install directory." && exit 1)
fi

cd $INSTALL_DIR || (echo "Failed to move into install directory." && exit 1)

echo "Downloading and running the set-wifi-credentials.sh script..."

wget --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/set-wifi-credentials.sh | bash -s $WIFI_NAME $WIFI_PASSWORD  || (echo "Failed to set WiFi credentials." && exit 1)


echo "Finished setting WiFi credentials."
